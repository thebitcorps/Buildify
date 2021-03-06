var BillingAdjusmentApp = React.createClass({
    //this could be done with mixins but mixins not working for some reason

    componentDidMount: function() {
        this.serverRequest = $.get('/billing_adjustments?payment_id='+this.props.payment_id, function (result) {
            this.setState({adjusments: result});
        }.bind(this),'json');
    },
    componentWillUnmount: function() {
        this.serverRequest.abort();
    },
    titleElement: function(text){
        return   (<h4 className="text-center cons-inf-title">
            <span className="text-muted">{text}</span>
        </h4>);
    },
    inputChange: function(name,value){
        var inputResponse = {};
        inputResponse[name] = value;
        this.setState(inputResponse);
    },
    getInitialState: function(){
      return {amount: '',adjustment_date: '',payment_type: 'check',reference: '',account: '',adjusments: [],paid_amount: parseInt(this.props.paid_amount),errors: []}
    },
    isValidAdjusment: function(){
        return this.state.amount && this.state.adjustment_date && this.state.payment_type && this.state.reference && this.state.account
    },
    submitBilling: function(){
        var billing = new BillingAdjusment(this.state.folio,this.state.amount,this.state.payment_type,this.state.adjustment_date,this.props.payment_id,this.state.reference,this.state.account);
        $.ajax({
            type: "POST",
            url: '/billing_adjustments',
            data: {billing_adjustment: billing},
            success: function(data){
                var billings = this.state.adjusments.slice();
                billings.unshift(data);
                this.setState({folio: '',amount: '',adjustment_date: '',payment_type: 'check',reference: '',account: '',adjusments: billings,paid_amount: this.state.paid_amount + parseFloat(billing.amount)});
            }.bind(this),
            error: function(XMLHttpRequest, textStatus, errorThrown){
                if(errorThrown == 'Internal Server Error'){
                    this.setState({ errors: ['Internal Server Error']});
                    return;
                }
                this.setState({ errors: $.parseJSON(XMLHttpRequest.responseText)});
            }.bind(this),
            dataType: 'JSON'
        });

    },
    updateBroswer: function(){


        $.ajax({
            type: "GET",
            url: '/payments/',
            data: {construction_id: this.props.construction_id},
            success: function(data){
                eval(data);

            }.bind(this),
            error: function(xhr, status, err) {
            },
            dataType: 'script'
        });
    },
    paymentTypeChange: function(newValue){
        var value = newValue == 'check' ? 'check' : 'transfer';
        this.setState({payment_type: value});
    },
    mapPaymentType: function(paymentType){
        return paymentType == 'check' ? 'Cheque' : 'Tranferencia'
    },
    billingadjusmentElement: function(element){
        return (<a className="list-group-item" key={element.id}>
                <h5>{this.mapPaymentType(element.payment_type)} por $ {parseFloat(element.amount).formatMoney(2)}</h5>
                <h6><i className="fa fa-calendar"></i> {element.adjustment_date}</h6>
                <h6><b>Cuenta:</b> {element.account}</h6>
                <h6><b>{element.payment_type == 'check'  ? 'Numero de cheque' : 'Numero de transaccion'}:</b> {element.reference}</h6>
        </a>)
    },
    render: function(){

        var account_message = this.state.payment_type == 'check'  ? 'Numero de cuenta de cheques' : 'Numero de cuenta';
        var reference_message = this.state.payment_type == 'check' ? 'Numero de cheque' : 'Numero de transaccion';
        var noBillingsMessage;
        if(this.state.adjusments.length == 0){
            noBillingsMessage = <a className="list-group-item" key={0}>No se han hecho abonos</a> ;
        }
        var balanceAmount = this.props.amount - this.state.paid_amount;
        var balanceMessage = "Total $" + this.props.amount.formatMoney(2)+ ", pagado $" + this.state.paid_amount.formatMoney(2) + " restante $" + balanceAmount.formatMoney(2);
        return (
            <div>
                <Modal title="Pago factura " parentNode="billing" modalClose={this.updateBroswer}>
                    <ErrorBox errorsArray={this.state.errors}/>
                    <div className="row">
                        <div className="col-sm-6">
                            {this.titleElement("Nuevo pago")}
                            <LabelInput addon="$" name="amount" label="Cantidad" changed={this.inputChange} type="number" value={this.state.amount}/>
                            <DateInput name="adjustment_date" label="Fecha del pago" changed={this.inputChange} value={this.state.adjustment_date}/>
                            <LabelSelect name="payment_type" label="Tipo de pago" onChanged={this.paymentTypeChange} options={[{display: 'Cheque',value: 'check'},{display: 'Transferencia',value: 'transfer'}]}/>
                            <LabelInput name="account" label={account_message} changed={this.inputChange} value={this.state.account}/>
                            <LabelInput name="reference" label={reference_message} changed={this.inputChange} value={this.state.reference}/>
                            <button className="btn btn-primary" disabled={!this.isValidAdjusment()} onClick={this.submitBilling}>Agregar</button>
                        </div>
                        <div className="col-sm-6">
                            {this.titleElement(balanceMessage)}
                            <div className="list-group"  style={{height: '500px  ',overflowY: 'auto'}}>
                            {
                                this.state.adjusments.map(function(item,index){
                                    return this.billingadjusmentElement( item)
                                }.bind(this))
                            }
                            {noBillingsMessage}
                            </div>
                        </div>
                    </div>
                </Modal>

            </div>
        )
    }



});