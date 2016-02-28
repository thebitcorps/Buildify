var PaymentForm = React.createClass({
    getInitialState: function(){
      return {payments: []}
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
        var payments = this.state.payments.slice();
        payments.push(payment);
        this.setState({payments: payments,amount: '',payment_date: moment().format('DD/MM/YYYY'),concept: ''});
    },

    paymentElement: function(heading,text,amount){
        return (<a className="list-group-item">
            <h4 className="list-group-item-heading">
                {heading}
                <div className="pull-right"><label className="label label-primary "> $ {amount} </label></div>
            </h4>
            <p className="list-group-item-text">{text}</p>

        </a>)
    },
    isValidPayment: function(){
      return this.state.concept && this.state.amount && this.state.payment_date
    },
    render: function(){
        var noPaymentMessage;
        if(this.state.payments.length == 0){
            noPaymentMessage = this.paymentElement('No se han agregado pagos',null,0);
        }
       return (
           <div className="row">
               <div className="col-md-6">
                   {this.titleElement('Agregar pagos')}
                   <LabelInput name="concept" label="Concepto" changed={this.inputChange} value={this.state.concept} />
                   <LabelInput name="amount" label="Cantidad" changed={this.inputChange} type="number" value={this.state.amount}/>
                   <DateInput name="payment_date" label="Fecha del gasto" changed={this.inputChange} value={this.state.payment_date}/>
                   <button className="btn btn-primary" onClick={this.addPayment} disabled={!this.isValidPayment()}>Agregar pago</button>
               </div>
               <div className="col-md-6" style={{height: 'calc(60vh - 212px)',overflowY: 'auto'}}>
                    {this.titleElement('Pagos agregados')}
                   <div className="list-group">
                        {this.state.payments.map(function(item){
                            return this.paymentElement( item.concept, item.payment_date,item.amount)
                            }.bind(this))
                        }
                        {noPaymentMessage}
                   </div>
               </div>
           </div>
       );
   },

});