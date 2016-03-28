var UnitaryPrice = React.createClass({

    render: function(){
        var button;
        if( this.props.itemMaterial.unit_price){
            button = <buttton className="btn btn-warning">Cambiar precio unitario</buttton>
        }else{
            button = <buttton className="btn btn-primary">Agregar precio unitario</buttton>
        }
        return (
            {button}

        );
    }
});