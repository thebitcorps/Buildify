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
      return {folio: '',amount: '',adjustment_date: '',payment_type: 'check',reference: '',account: '',adjusments: [],paid_amount: parseInt(this.props.paid_amount)}
    },
    isValidAdjusment: function(){
        return this.state.folio && this.state.amount && this.state.adjustment_date && this.state.payment_type && this.state.reference && this.state.account
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
                this.setState({adjusments: billings,paid_amount: this.state.paid_amount + parseFloat(billing.amount)});
            }.bind(this),
            error: function(xhr, status, err) {
                //TODO add error box
                console.log(xhr + ' ' +status + " "+ err);
                if (err == 'Internal Server Error') {
                    alert("Error de servidor");
                    return;
                }
                alert($.parseJSON(xhr.responseText));
            },
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
            <h5 className="list-group-item-heading">
                Folio: {element.folio}
                <div className="pull-right">{this.mapPaymentType(element.payment_type)}<label className="label label-primary "> $ {parseFloat(element.amount).formatMoney(2)} </label></div>
            </h5>
            <div className="list-group-item-text">,
                <ul>
                    <li><b>Fecha:</b> {element.adjustment_date}</li>
                    <li><b>Cuenta:</b> {element.account}</li>
                    <li><b>{this.state.payment_type == 'check'  ? 'Numero de cheque' : 'Numero de transaccion'}:</b> {element.reference}</li>
                </ul>
            </div>
        </a>)
    },
    render: function(){

        var reference_message = this.state.payment_type == 'check'  ? 'Numero de cheque' : 'Numero de transaccion';
        var noBillingsMessage;
        if(this.state.adjusments.length == 0){
            noBillingsMessage = <a className="list-group-item" key={0}>No se han hecho abonos</a> ;
        }

        var child = <div className="row">
            <div className="col-sm-6">
                {this.titleElement("Nuevo pago")}
                <LabelInput  name="folio" label="Folio" changed={this.inputChange} value={this.state.folio} />
                <LabelInput addon="$" name="amount" label="Cantidad" changed={this.inputChange} type="number" value={this.state.amount}/>
                <DateInput name="adjustment_date" label="Fecha del pago" changed={this.inputChange} value={this.state.adjustment_date}/>
                <LabelSelect name="payment_type" label="Tipo de pago" onChanged={this.paymentTypeChange} options={[{display: 'Cheque',value: 'check'},{display: 'Transferencia',value: 'transfer'}]}></LabelSelect>
                <LabelInput name="reference" label={reference_message} changed={this.inputChange} value={this.state.reference}></LabelInput>
                <LabelInput name="account" label="Cuenta que se deposito" changed={this.inputChange} value={this.state.account} ></LabelInput>
                <button className="btn btn-primary" disabled={!this.isValidAdjusment()} onClick={this.submitBilling}>Agregar</button>
            </div>
            <div className="col-sm-6">
                <div className="list-group"  style={{height: '500px  ',overflowY: 'auto'}}>
                {this.titleElement("Saldo $" + this.props.amount.formatMoney(2)+ ",Pagado $" + this.state.paid_amount.formatMoney(2))}
                {
                    this.state.adjusments.map(function(item,index){
                    return this.billingadjusmentElement( item)
                    }.bind(this))
                }
                {noBillingsMessage}
                </div>
            </div>
        </div>;


        return (
            <div>
                <Modal title="Pago factura " body={child} parentNode="billing" modalClose={this.updateBroswer}/>
            </div>
        )
    }



});