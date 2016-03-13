//ReactDOM.render(React.createElement(Modal,{body: React.createElement(PaymentForm),construction_id: #{@construction.id}}),document.getElementById('mod'));
var PaymentModal = React.createClass({
  render: function(){
      var child = <PaymentForm construction_id={this.props.construction_id}/>;
      return (
        <div>
            <Modal body={child} modalClose={this.updateBroswer} title="Nuevo Gasto"/>
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