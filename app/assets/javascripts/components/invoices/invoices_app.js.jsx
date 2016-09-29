var InvoicesApp = React.createClass({
    INDEX_TAB_NAME: 'index',
    ASSIGN_TAB_NAME: 'assign',
    componentDidMount: function() {
        this.serverRequest = $.get('/invoices?purchase_order_id='+this.props.purchase_order_id, function (result) {
            this.setState({invoices: result});
        }.bind(this),'json');
    },
    componentWillUnmount: function() {
        this.serverRequest.abort();
    },
    getInitialState: function () {
        return {active_tab: 'index', invoices: [ ], adding: false, editing: false, adding_list_count: 0}
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
    updateAddingList: function (count) {
        this.setState({adding_list_count: count})
    },
    addNewInvoice: function (invoice) {
        var invoices = this.state.invoices.slice();
        invoices.push(invoice);
        this.setState({invoices: invoices});
    },
    invoiceAdded: function (invoice) {
        this.addNewInvoice(invoice);
        this.changeActiveTab(this.INDEX_TAB_NAME);
    },
    getNoInvoicesMessage: function () {
        if(this.state.invoices.length == 0){
            return <a className="list-group-item" >
                <h4 className="list-group-item-heading">No hay facturas</h4>
            </a>;
        }else{
            return null;
        }
    },
    getIndexBody: function () {
        var  column_class, invoice_form, invoice_list;

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
            invoice_list = this.getInvoiceList(column_class);
        }

      return (
          <div className="row">
              {invoice_form}
              {invoice_list}
          </div>
      );
    },
    getInvoiceList: function (column_class) {
       return  <ul className={column_class} style={{height: '480px  ',overflowY: 'auto'}}>
           <div className="list-group">
               {
                   this.state.invoices.map(function(item){
                       return <Invoice invoice={item} btn_message="Editar" btn_click={this.toggleEditing} key={item.id}/>;
                   }.bind(this))
               }
               {this.getNoInvoicesMessage()}
           </div>
       </ul>;
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
            adding_button = null;
            active_body = <AddInvoice invoices={this.state.invoices} purchase_order_id={this.props.purchase_order_id} construction_id={this.props.construction_id} onInvoiceAdded={this.invoiceAdded} sendListCount={this.updateAddingList}/>;
        }
       return (
         <div>
             <div className="pull-right">
                 {adding_button}
             </div>
             <ul className="nav nav-tabs">
                 <li role="presentation" className={this.isTabActice(this.INDEX_TAB_NAME)} onClick={() => this.changeActiveTab(this.INDEX_TAB_NAME)}><a href="#">Invoices {this.state.invoices.length}</a></li>
                 <li role="presentation" className={this.isTabActice(this.ASSIGN_TAB_NAME)} onClick={() => this.changeActiveTab(this.ASSIGN_TAB_NAME)}><a href="#">Asignar {this.state.adding_list_count}</a></li>
             </ul>
             {active_body}
         </div>  
       );
   } 
});