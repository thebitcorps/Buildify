var UnitaryPrice = React.createClass({
    getInitialState: function(){
        return {edit: false,unit_price: this.props.itemMaterial.unit_price};
    },
    changeEditState: function(){
      this.setState({edit: !this.state.edit,unit_price: this.props.itemMaterial.unit_price});
    },
    inputChange: function(name,value){
        var inputResponse = {};
        inputResponse[name] = value;
        this.setState(inputResponse);
    },
    submitUnitPrice: function(){
        $.ajax({
                type: "PUT",
                url: '/item_materials/'+this.props.itemMaterial.id,
                data: {item_material: {unit_price: this.state.unit_price}},
                success: function(data){
                    this.setState({edit: false,unit_price: data.unit_price})
                }.bind(this),
                error: function(XMLHttpRequest, textStatus, errorThrown){
                    if(errorThrown == 'Internal Server Error'){
                        this.setState({ errors: ['Internal Server Error']});
                        return;
                    }
                    this.setState({ errors: $.parseJSON(XMLHttpRequest.responseText)});
                    alert(XMLHttpRequest.responseText);
                }.bind(this),
                dataType: 'JSON'
            }

        );
    },
    render: function(){
        var button= null,input= null,label=null;
        if(this.state.edit){
            button = <div>
                <buttton className="btn btn-primary" onClick={this.submitUnitPrice}>Guardar</buttton>
                <button className="btn btn-default" onClick={this.changeEditState}>Cancelar</button></div>;

            input = <LabelInput placeholder="$ Precio unitario" name="unit_price" changed={this.inputChange} type="number" value={this.state.unit_price}/>;
        }
        else{
            var message = "Agregar ";
            if(this.state.unit_price){
                message = "Cambiar ";
                label = "$" + parseInt(this.state.unit_price).formatMoney();

            }
            button = <buttton className="btn btn-primary" onClick={this.changeEditState}>{message}</buttton>
        }
        return (
            <div className="row">
                {input}
                {label}
                {button}
            </div>

        );
    }
});