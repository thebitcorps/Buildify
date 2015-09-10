@ErrorBox = React.createClass

  render: ->
    React.DOM.div
      className: "panel panel-danger"
      React.DOM.div
        className: 'panel-heading'
        'Errores'
      React.DOM.div
        className: 'panel-body'
        @props.errorsArray
#          for error in @props.errorsArray
#            React.DOM.ul null,
#              React.DOM.li null,
#                error