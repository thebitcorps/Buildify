var CheckboxInput = React.createClass({
    getInitialState: function () {
        return {
            checked: this.props.checked || false
        };
    },
    render: function () {
        return (
            <label className='radio-inline'>
                <input type="checkbox"
                    name={this.props.name}
                    checked={this.state.checked}
                    onChange={this.handleClick}
                    value={this.props.value} />
              {this.props.label}
            </label>
        );
    },
    handleClick: function(e) {
        this.setState({checked: e.target.checked});
        this.props.changed(e.target.name,e.target.checked);
    }
});

