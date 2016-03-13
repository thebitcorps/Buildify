var BillingAdjusmentApp = React.createClass({
    //this coulb be done with mixins but mixins not working for some reason
    titleElement: function(text){
        return   (<h4 className="text-center cons-inf-title">
            <span className="text-muted">{text}</span>
        </h4>);
    },
    render: function(){

        var child = <div className="row">
            <div className="col-sm-6">
                {this.titleElement("Nuevo pago")}
            </div>
            <div className="col-sm-6">
                {this.titleElement("Pagos hechos")}
            </div>
        </div>;


        return (
            <div>
                <Modal title="Pago factura " body={child}/>
            </div>
        )
    }



});