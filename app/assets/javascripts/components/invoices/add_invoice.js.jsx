var AddInvoice = React.createClass({
    getInitialState: function () {
        return {invoices: [], folio: ''}
    },
    componentDidMount: function() {
        this.invoice_page = 1;
        //Gets all the inovoices that are not in the purchase order
        this.serverRequest = $.get('/invoices', function (result) {
            var invoices = this.removeDuplicatedInvoices(result, this.props.invoices);
            this.invoces = invoices;
            this.setState({invoices: invoices});
            this.props.sendListCount(result.length);
        }.bind(this),'json');
    },
    // bringNextPage: function(){
    //     this.invoice_page += 1;
    //     this.serverRequest = $.get('/invoices?not_from=true&purchase_order_id='+this.props.purchase_order_id + 'page=' + this.invoice_page, function (result) {
    //         var new_invoices = this.removeDuplicatedInvoices(result, this.props.invoices);
    //         var state_invoice = this.state.invoices.slice();
    //         var merge = state_invoice.concat(new_invoices);
    //         console.log(merge);
    //         this.setState({invoices: merge});
    //         this.props.sendListCount(merge.length);
    //     }.bind(this),'json');
    // },
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
    filterByFolio: function (name,value) {
        if(value == ''){
            this.setState({invoices: this.invoces, folio: value});
            return;
        }
        var filtered_invoices = this.invoces.filter(function (invoice) {
            return invoice.folio.indexOf(value) !== -1;
        });
        this.setState({invoices: filtered_invoices, folio: value});
    },
    render: function () {
        var invoices;
        invoices = this.state.invoices.map(function (invoice) {
            return <Invoice invoice={invoice} btn_message="Agregar" btn_click={this.addInvoiceToPurchase}/>;
        }.bind(this));
        return (
          <div>
              <ErrorBox errorsArray={this.state.errors}/>
              <div className="col-md-3"><LabelInput name="folio" label="Buscar por folio" changed={this.filterByFolio} value={this.state.folio} /></div>
              <div className="list-group" style={{height: '480px  ',overflowY: 'auto'}} >
                {invoices}
                {this.getNoInvoicesMessage()}
              </div>
          </div>
        );
    }
});