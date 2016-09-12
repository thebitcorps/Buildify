//ReactDOM.render(React.createElement(Modal,{body: React.createElement(PaymentForm),construction_id: #{@construction.id}}),document.getElementById('mod'));
var CompleteEstimateModal = React.createClass({
    getInitialState: function () {
        return {payment_date: ''}
    },
    inputChange: function(name,value){
        var inputResponse = {};
        inputResponse[name] = value;
        this.setState(inputResponse);
    },
    finishComponent: function () {
        $('#modal').modal('hide');
    },
    submitEstimation: function () {
        $.ajax({
            type: "PATCH",
            url: '/estimates/' +this.props.estimate_id ,
            data:  {estimate: this.state},
            success: function(data){
                location.reload();
            }.bind(this),
            error: function(xhr, status, err) {
                alert("Error al aceptar");
                this.finishComponent();
            }.bind(this),
            dataType: 'json'
        });
    },
    render: function(){

        return (
            <div>
                <Modal title="Fecha de autorizacion" size="sm">
                    <DateInput name="payment_date" label="Fecha del pago" changed={this.inputChange} value={this.state.payment_date}/>
                    <button className="btn btn-primary" onClick={this.submitEstimation}>Guardar</button>
                    <button className="btn btn-default" onClick={this.finishComponent}>Cancelar</button>
                </Modal>
            </div>
        );
    }
});