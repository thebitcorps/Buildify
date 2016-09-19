var InvoicesApp = React.createClass({
    INDEX_TAB_NAME: 'index',
    ASSIGN_TAB_NAME: 'assign',
   getInitialState: function () {
       return {active_tab: 'index', invoices: this.props.invoices, adding: false, editing: false}
   },
    isTabActice: function (tab_name) {
        return this.state.active_tab == tab_name ? 'active' : '';
    },
    changeActiveTab: function(tab_name){
      if(this.isTabActice(tab_name) == 'active'){
          return;
      }
      this.setState({active_tab: tab_name});
    },
    invoiceElement: function (invoice) {
        return (
            <div className="list-group-item" key={invoice.id}>
                <h4 className="list-group-item-heading">
                    Folio: {invoice.folio}
                    <div className="pull-right"><button className="btn btn-primary" onClick={()=> this.toggleEditing(invoice)}>Editar</button></div>

                    <a href={"/invoices/" + invoice.id+ "/document"}>
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
    toggleAdding: function () {
        this.setState({adding: !this.state.adding, active_tab: this.INDEX_TAB_NAME, editing: false, editing_invoice: null});
    },
    toggleEditing: function (invoice) {
        this.setState({editing: !this.state.editing, active_tab: this.INDEX_TAB_NAME, editing_invoice: invoice});
    },
    replaceOld: function (invoice) {
        var invoices = this.state.invoices.slice();
        for(var  i = 0; i < invoices.length; i++){
            if(invoice.id == invoices[i].id){
                invoices[i] = invoice;
                break;
            }
        }
        this.setState({invoices: invoices, editing_invoice: null});
    },
    addNewInvoice: function (invoice) {
        var invoices = this.state.invoices.slice();
        invoices.push(invoice);
        this.setState({invoices: invoices});
    },
    getIndexBody: function () {
        var no_invoices, column_class, invoice_form, invoice_list;
        if(this.state.invoices.length == 0){
            no_invoices = <a className="list-group-item" >
                <h4 className="list-group-item-heading">No hay facturas</h4>
            </a>;
        }else{
            no_invoices = null;
        }
        if(this.state.editing){
            invoice_form = <div className="col-md-12"><InvoiceForm invoice={this.state.editing_invoice} cancelForm={this.toggleEditing} invoiceAdded={this.replaceOld}/></div>
        } else{
            if(!this.state.adding){
                invoice_form = null;
                column_class = 'col-md-12';

            }else{
                column_class = 'col-md-6';
                invoice_form = <div className="col-md-6"><InvoiceForm purchase_order_id={this.props.purchase_order_id} cancelForm={this.toggleAdding} invoiceAdded={this.addNewInvoice}/></div>
            }
            //TODO make function
            invoice_list =<ul className={column_class} style={{height: '480px  ',overflowY: 'auto'}}>
                <div className="list-group">
                    {
                        this.state.invoices.map(function(item){
                            return this.invoiceElement(item);
                        }.bind(this))
                    }
                    {no_invoices}
                </div>
            </ul>;

        }

      return (
          <div className="row">
              {invoice_form}
              {invoice_list}
          </div>
      );
    },
    render: function () {
        var active_body, adding_button;
        if(this.state.editing){
            adding_button = null;
        }
        else if(!this.state.adding){
            adding_button = <button className="btn btn-primary" onClick={this.toggleAdding}>Agregar</button>;
        }else{
            adding_button = <button className="btn btn-default" onClick={this.toggleAdding}>Cancelar</button>
        }
        if(this.state.active_tab == this.INDEX_TAB_NAME){
            active_body = this.getIndexBody();
        }else{
            active_body = <div></div>;
        }
       return (
         <div>
             <div className="pull-right">
                 {adding_button}
             </div>
             <ul className="nav nav-tabs">
                 <li role="presentation" className={this.isTabActice(this.INDEX_TAB_NAME)} onClick={() => this.changeActiveTab(this.INDEX_TAB_NAME)}><a href="#">Invoices</a></li>
                 <li role="presentation" className={this.isTabActice(this.ASSIGN_TAB_NAME)} onClick={() => this.changeActiveTab(this.ASSIGN_TAB_NAME)}><a href="#">Asignar </a></li>
             </ul>
             {active_body}
         </div>  
       );
   } 
});