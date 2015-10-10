@LabelRadio = React.createClass
#  getInitialState: ->
#    checked: @props.checked
  changed: (e) ->
    @props.changed  e.target.name,e.target.value
  getDefaultProps: ->
    disable: false
    checked: false
  render: ->
      React.DOM.label
        className: 'radio-inline'
        React.DOM.input
          disabled: @props.disabled
          type: 'radio'
          checked: @props.checked
          name: @props.name
          id: @props.id
          value: @props.value
          onChange: @changed
        @props.label


