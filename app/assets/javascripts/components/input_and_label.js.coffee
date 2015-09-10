@LabelInput = React.createClass

  changed: (e) ->
    @props.changed  e.target.name,e.target.value
  render: ->
    React.DOM.div
      className: 'form-group'
      if @props.label
        React.DOM.label
          className: 'control-label'
          @props.label
      React.DOM.input
        type: 'text'
        className: 'form-control'
        placeholder: @props.placeholder
        name: @props.name
        value: @props.value
        onChange: @changed


