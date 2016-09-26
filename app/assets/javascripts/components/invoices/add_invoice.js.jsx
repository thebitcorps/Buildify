var AddInvoice = React.createClass({
    getInitialState: function () {
        return {invoices: []}
    },
    componentDidMount: function() {
        //Gets all the inovoices that are not in the purchase order
        //TODO add pagination
        this.serverRequest = $.get('/invoices?not_from=true&purchase_order_id='+this.props.purchase_order_id, function (result) {
            var invoices = this.removeDuplicatedInvoices(result, this.props.invoices);
            this.setState({invoices: invoices});
        }.bind(this),'json');
    },
    componentWillUnmount: function() {
        this.serverRequest.abort();
    },
    //TODO change to binary search because this will work with small arrays
    //log(n*n)
    removeDuplicatedInvoices: function (server_invoices, props_invoices) {
        return server_invoices.filter(function (current) {
            return props_invoices.filter(function (current_props) {
                return current.id == current_props.id;
            }).length == 0
        });
    },
    addInvoiceToPurchase: function(invoice){
        var result = confirm("Desea agregar esta factura a la orden de compra?");
        if(!result) return;
        var payment = {amount: 0, payment_date: invoice.invoice_date, purchase_order_id: this.props.purchase_order_id, invoice_id: invoice.id,construction_id: this.props.construction_id};
        $.ajax({
            dataType: 'JSON',
            type: 'POST',
            url: '/payments',
            data: {payment: payment},
            success: function(data){
                this.props.onInvoiceAdded(invoice);
            }.bind(this),
            error: function(XMLHttpRequest, textStatus, errorThrown){
                if(errorThrown == 'Internal Server Error'){
                    this.setState({ errors: ['Internal Server Error']});
                    return;
                }
                this.setState({ errors: $.parseJSON(XMLHttpRequest.responseText)});
            }.bind(this)
        });
        
    },
    invoiceElement: function (invoice) {
        return (
            <div className="list-group-item" key={invoice.id}>
                <h4 className="list-group-item-heading">
                    Folio: {invoice.folio}
                    <div className="pull-right"><button className="btn btn-primary" onClick={()=> this.addInvoiceToPurchase(invoice)}>Agregar a orden</button></div>
                    <a href={"/invoices/" + invoice.id+ "/document"} target="_blank">
                        <img className="pdf-icon"  alt="Pdf icon" src="/assets/pdf-icon-8cbf78af37779857c322c4020429d65733cb89435a9e513f8d5e3ed9113e809e.png"/>
                    </a>
                </h4>

                <label className="label label-primary ">{invoice.status}</label>
                <h6><b>Folio Factura: </b>{invoice.receipt_folio}</h6>
                <h6><i className="fa fa-usd"/>  {invoice.amount}</h6>
                <h6><i className="fa fa-calendar"/>  {invoice.invoice_date}</h6>
            </div>
        );
    },
    render: function () {
        var invoices;
        invoices = this.state.invoices.map(function (invoice) {
            return this.invoiceElement(invoice);
        }.bind(this));
        return (
          <div>
              <ErrorBox errorsArray={this.state.errors}/>
              <div className="list-group">
                {invoices}
              </div>
          </div>
        );
    }
});