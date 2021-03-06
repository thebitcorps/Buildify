var Invoice = React.createClass({
   render: function () {
       //TODO add status
       // <label className="label label-primary ">{this.props.invoice.status}</label>
       var provider = this.props.invoice.provider;
       return (
           <div className="list-group-item" >
               <h4 className="list-group-item-heading">
                   Folio: {this.props.invoice.folio}
                   <div className="pull-right"><button className="btn btn-primary" onClick={()=> this.props.btn_click(this.props.invoice)}>{this.props.btn_message}</button></div>

                   <a href={"/invoices/" + this.props.invoice.id+ "/document"} target="_blank">
                       <img className="pdf-icon"  alt="Pdf icon" src="/assets/pdf-icon-8cbf78af37779857c322c4020429d65733cb89435a9e513f8d5e3ed9113e809e.png"/>
                   </a>
               </h4>
               <h6><b>Provedor: </b><a href={"/providers/"+ provider.id} target="_blank">{provider.name}</a></h6>
               <h6><b>Folio Factura: </b>{this.props.invoice.receipt_folio}</h6>
               <h6><i className="fa fa-usd"/>  {this.props.invoice.amount}</h6>
               <h6><i className="fa fa-calendar"/>  {this.props.invoice.invoice_date}</h6>
           </div>  
       );
   } 
});