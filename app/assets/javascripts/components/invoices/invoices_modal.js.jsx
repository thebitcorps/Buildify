var InvoicesModal = React.createClass({

    render: function () {
        return (
            <Modal title="Invoices" parentNode="invoices" >
                <InvoicesApp purchase_order_id={this.props.purchase_order_id} invoices={this.props.invoices}/>
            </Modal>
        );
    }
});