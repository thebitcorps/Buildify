#component that uses jquery tokenizer for returning data
#defaultProps
#@props.componentName: this will be use for creating the nesesary inputs to ake token input work
#                     default 'token-input'
#@props.url: the path for the post method to use for posting the new item
#             default ''
#@props.queryParam: the param to append to the post messsage of the input
#@props.onAddToken: funtion to notify the parent of the item added the function it recives should have one param
#                   this will be the object returned by the query
#@props.onRemoveToken: funtion to notify the parent of the item was remove the function it recives should have one param
#                       this will be the token was removed
@TokenInput = React.createClass
  getDefaultProps: ->
    componentName: 'token-input'
    url: ''
    queryParam: 'search[query]'
  componentDidMount: ->
    state = @
    $("#" + state.props.componentName).tokenInput(state.props.url, {
      crossDomain: false,
#      prePopulate: $("#material").data("pre"),
      theme: "facebook"
      queryParam: state.props.queryParam
      tokenLimit: 1
      onAdd: (item) ->
        state.props.onAddToken item
      onDelete: (item) ->
        state.props.onRemoveToken item
    })
  render: ->
    React.DOM.div
      className: 'token-input'
      React.DOM.input
        type: 'text'
        id: @props.componentName
        placeholder: @props.componentName
        ref: @props.componentName
        name: @props.componentName


