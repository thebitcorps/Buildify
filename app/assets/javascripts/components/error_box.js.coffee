#simple panel for showing errors in ul
#Props
#@props.errorArray: list of error for displaying in a single array
@ErrorBox = React.createClass
  getDefaultProps: ->
    errosArray: []
  render: ->
    if @props.errorsArray.length > 0
#      add a X to remove the box if user don't want to see it anymore
      React.DOM.div
        className: "panel panel-danger"
        React.DOM.div
          className: 'panel-heading'
          "Errores (#{@props.errorsArray.length})"
        React.DOM.div
          className: 'panel-body'
          for error in @props.errorsArray
            React.DOM.ul null,
              React.DOM.li null,
                error
    else
      React.DOM.div
        className: 'errors'