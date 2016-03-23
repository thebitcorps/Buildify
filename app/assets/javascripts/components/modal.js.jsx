/**
 *
 */
var Modal = React.createClass({
    propTypes: {
        body: React.PropTypes.element,
        footer: React.PropTypes.element
    },
    getDefaultProps: function(){
        return {name: 'modal',number: '0',parentNode: 'mod',modalClose: function(){},size: 'lg'}
    },
    closeModal: function() {
        this.modal.modal('hide');
    },
    componentDidMount: function(){
        this.modal = $('#'+this.props.name);
        this.modal.modal();
        this.modal.on('hidden.bs.modal',function(){
            ReactDOM.unmountComponentAtNode(document.getElementById(this.props.parentNode));
            this.props.modalClose();
        }.bind(this));
    },

    render: function() {
        return (
            <div>
                <div id={this.props.name} tabIndex='-1' role='modal' className='modal fade' onRequestClose={this.closeModal} closeTimeoutMS='0'>
                    <div className={'modal-dialog modal-'+ this.props.size}>
                        <div className="modal-content">
                            <div className="modal-header">
                                <button type="button" className="close" onClick={this.closeModal}>
                                    <span aria-hidden="true">&times;</span>
                                    <span className="sr-only">Close</span>
                                </button>
                                <h3 className="modal-title">{this.props.title}</h3>
                            </div>
                            <div className="modal-body">
                            {this.props.children}
                            </div>
                            <div className="modal-footer">
                            {this.props.footer}
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        );
    }
});
