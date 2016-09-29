var AddInvoice = React.createClass({
    getInitialState: function () {
        this.first_date = true;
        return {invoices: [], folio: '',invoice_date: '',receipt_folio: ''}
    },
    componentDidMount: function() {
        $('#clear-date').tooltip();
        //Gets all the inovoices that are not in the purchase order
        this.serverRequest = $.get('/invoices', function (result) {
            var invoices = this.removeDuplicatedInvoices(result, this.props.invoices);
            this.invoces = invoices;
            this.setState({invoices: invoices});
            this.props.sendListCount(result.length);
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
    getNoInvoicesMessage: function () {
        if(this.state.invoices.length == 0){
            return <a className="list-group-item" >
                <h4 className="list-group-item-heading">No hay facturas para agregar</h4>
            </a>;
        }else{
            return null;
        }
    },
    filterBy: function (name, value) {
        var filtered_invoices = this.invoces.filter(function (invoice) {
            return invoice[name].indexOf(value) !== -1;
        });
        var object = {invoices: filtered_invoices};
        object[name] = value;
        this.setState(object);
    },
    filterByDate: function (name, value) {
        if(this.first_date){
            this.first_date = false;
        }else{
            this.filterBy(name, value);
        }
    },
    clearDate: function(){
        this.filterBy('invoice_date', '');

    },
    render: function () {
        var invoices;
        invoices = this.state.invoices.map(function (invoice) {
            return <Invoice invoice={invoice} btn_message="Agregar" btn_click={this.addInvoiceToPurchase} key={invoice.id}/>;
        }.bind(this));
        
        return (
          <div>
              <ErrorBox errorsArray={this.state.errors}/>
              <div className="col-sm-3">
                  <LabelInput name="folio" label="Buscar por folio" changed={this.filterBy} value={this.state.folio} />
                  <LabelInput name="receipt_folio" label="Buscar por folio de factura" changed={this.filterBy} value={this.state.receipt_folio} />
                  <DateInput  minDate="10000" name="invoice_date" label="Fecha factura" changed={this.filterByDate} value={this.state.invoice_date}/>
                  <button id="clear-date" className="btn btn-default btn-xs"onClick={this.clearDate} data-toggle="tooltip" data-placement="right" title="Limpiar fecha">X</button>
              </div>
              <div className="list-group" style={{height: '480px  ',overflowY: 'auto'}} >
                {invoices}
                {this.getNoInvoicesMessage()}
              </div>
          </div>
        );
    }
});