var PaymentForm = React.createClass({
    getInitialState: function(){
      return {payments: [],paid_amount: true,payment_type: 'other'}
    },
    componentDidMount: function() {
        this.serverRequest = $.get('/payments?construction_id='+this.props.construction_id + '&type_list=petty_cash', function (result) {
            this.setState({payments: result});
        }.bind(this),'json');
    },
    componentWillUnmount: function() {
        this.serverRequest.abort();
    },
    inputChange: function(name,value){
        var inputResponse = {};
        inputResponse[name] = value;
        this.setState(inputResponse);
    },
    titleElement: function(text){
     return   (<h4 className="text-center cons-inf-title">
         <span className="text-muted">{text}</span>
        </h4>);
    },
    addPayment: function(){
        //concept,amount,payment_date,construction_id)
        var payment = new Payment(this.state.concept,this.state.amount,this.state.payment_date,this.props.construction_id);
        if(this.state.paid_amount){
            payment['paid_amount'] = this.state.amount;
            payment['status'] = 'paid';
        }
        $.ajax({
            type: "POST",
            url: '/payments',
            data: {payment: payment},
            success: function(data){
                var payments = this.state.payments.slice();
                payments.push(payment);
                this.setState({payments: payments,amount: '',payment_date: moment().format('DD/MM/YYYY'),concept: ''});
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
    radioChange: function(name,value){
        this.setState({payment_type: value});
    },
    paymentElement: function(heading,text,amount,key){
        return (<a className="list-group-item" key={key}>
            <h4 className="list-group-item-heading">
                {heading}
                <div className="pull-right"><label className="label label-primary "> $ {parseFloat(amount).formatMoney(2)} </label></div>
            </h4>
            <p className="list-group-item-text">{text}</p>

        </a>)
    },
    isValidPayment: function(){
      return this.state.concept && this.state.amount && this.state.payment_date
    },
    render: function(){
        var noPaymentMessage,paymentsAcummulate= 0,i,conceptLabel,adddonConcept = null;
        if(this.state.payments.length == 0){
            noPaymentMessage = this.paymentElement('No se han agregado pagos',null,0);
        }
        for(i = 0;i < this.state.payments.length;i++){
            paymentsAcummulate += parseInt(this.state.payments[i].amount);
        }
        if(this.state.payment_type == 'other'){
            conceptLabel = "Concepto";
        }
        else if(this.state.payment_type == 'gas'){
            conceptLabel = "Nombre a la persona que se entrego";
            adddonConcept = "Gas";
        }
        else if(this.state.payment_type == 'phone'){
            conceptLabel = "Telefono";
            adddonConcept = moment().format('MMMM');
        }
       return (
           <div className="row">
               <div className="col-sm-6" ref="a">
                   {this.titleElement('Agregar gasto')}
                   <LabelRadio name="other" value="other" label="Otro" changed={this.radioChange} checked={this.state.payment_type == 'other'}/>
                   <LabelRadio name="gas" value="gas" label="Gasolina" changed={this.radioChange} checked={this.state.payment_type == 'gas'}/>
                   <LabelRadio name="phone" value="phone" label="Telefono" changed={this.radioChange} checked={this.state.payment_type == 'phone'}/>
                   <LabelInput addon={adddonConcept} name="concept" label={conceptLabel} changed={this.inputChange} value={this.state.concept} />;
                   <LabelInput addon="$" name="amount" label="Cantidad" changed={this.inputChange} type="number" value={this.state.amount}/>
                   <DateInput name="payment_date" label="Fecha del gasto" changed={this.inputChange} value={this.state.payment_date}/>
                   <CheckboxInput name="paid_amount" changed={this.inputChange} label="Ya fue liquidado" checked={this.state.paid_amount}/>
                        {/*TODO provider input*/}
                   <br/>
                   <button className="btn btn-primary" onClick={this.addPayment} disabled={!this.isValidPayment()}>Agregar pago</button>

               </div>
               <div className="col-sm-6">
                    {this.titleElement('Gastos agregados $' + parseInt(paymentsAcummulate).formatMoney(2))}
                   <div className="list-group"  style={{height: '290px  ',overflowY: 'auto'}}>
                        {this.state.payments.map(function(item,index){
                            return this.paymentElement( item.concept, item.payment_date,item.amount,index)
                            }.bind(this))
                        }
                        {noPaymentMessage}
                   </div>
               </div>
           </div>
       );
   }

});