#An select field with label that update the parent state with the given aame and the option selected
#default props
#@props.option: it should be an array of hashes [{display , value},{display , value}] defaull[]
#@props.name: the name of the select input also this will be the id
#@props.label: string to display on the label if null no label will display
#@props.defaultValue: the initial value for the select could be null
@LabelSelect = React.createClass
  getDefaultProps: ->
    options: []
  changed: (e) ->
    @props.onChanged e.target.value
  render: ->
    React.DOM.div
      className: 'form-group'
      if @props.label
        React.DOM.label
          className: 'control-label'
          @props.label
      React.DOM.select
        className: 'form-control'
        name: @props.name
        id: @props.name
        onChange: @changed
        for option,index in @props.options
          React.DOM.option
            #its okay to use the index here because this opton is not dinamic now
            key: index
            value: option.value
            option.display