var InvoicesModal = React.createClass({

    render: function () {
        return (
            <Modal title={'Facturas de orden ' + this.props.folio } parentNode="invoices" >
                <InvoicesApp purchase_order_id={this.props.purchase_order_id} construction_id={this.props.construction_id}/>
            </Modal>
        );
    }
});