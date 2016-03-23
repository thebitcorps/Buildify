//ReactDOM.render(React.createElement(Modal,{body: React.createElement(PaymentForm),construction_id: #{@construction.id}}),document.getElementById('mod'));
var PaymentModal = React.createClass({
  render: function(){

      return (
        <div>
            <Modal modalClose={this.updateBroswer} title="Nuevo Gasto">
                <PaymentForm construction_id={this.props.construction_id}/>;
            </Modal>

        </div>
      );
  },
    updateBroswer: function(){
        $.ajax({
            type: "GET",
            url: '/payments/',
            data: {construction_id: this.props.construction_id},
            success: function(data){
                eval(data);
            }.bind(this),
            error: function(xhr, status, err) {
            },
            dataType: 'script'
        });
    }
});