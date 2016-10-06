var InvoiceForm = React.createClass({
    getInitialState: function () {
        if(this.props.invoice != null){
            this.editing = true;
            return {receipt_folio: this.props.invoice.receipt_folio, invoice_date: this.props.invoice.invoice_date, amount: this.props.invoice.amount,observations: this.props.invoice.observations};
        }
        this.editing = false;
      return {receipt_folio: '', invoice_date: '', amount: 0, observations: ''};
    },
    inputChange: function(name,value){
        var inputResponse = {};
        inputResponse[name] = value;
        this.setState(inputResponse);
    },
    isValidInvoice: function () {
      return this.state.receipt_folio && this.state.invoice_date && this.state.amount;
    },
    addInvoice: function () {
        var method, url;
        if(this.editing){
            method = "PATCH";
            url = '/invoices/' + this.props.invoice.id;
        }else{
            method = 'POST';
            url = '/invoices';
        }
        $.ajax({
            type: method,
            url: url,
            data: {invoice: this.state, purchase_order_id: this.props.purchase_order_id},
            success: function(data){
                this.setState(this.getInitialState());
                this.props.invoiceAdded(data);
                this.props.cancelForm();
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
   render: function () {
       var message;
       if(this.editing){
           message = <h3>Editando</h3>
       }else{
           message = <h3>Nuevo</h3>
       }
       return (
         <div>
             <ErrorBox errorsArray={this.state.errors}/>
             {message}
             <LabelInput name="receipt_folio" label="Folio de factura" changed={this.inputChange} value={this.state.receipt_folio} />
             <LabelInput addon="$" name="amount" label="Cantidad" changed={this.inputChange} type="number" value={this.state.amount}/>
             <DateInput name="invoice_date" label="Fecha de recibida" changed={this.inputChange} value={this.state.invoice_date}/>
             <LabelInput name="observations" label="Observaciones" changed={this.inputChange} value={this.state.observations}/>
             <button className="btn btn-primary" onClick={this.addInvoice} disabled={!this.isValidInvoice()}>Agregar invoice</button>
             <button className="btn btn-default" onClick={this.props.cancelForm}>Cancelar</button>
         </div>  
       );
   }
});