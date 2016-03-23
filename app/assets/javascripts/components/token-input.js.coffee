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
#@props.withDescription: will format li result item iwth description with the response
@TokenInput = React.createClass
  displayName: 'Token input'
  getDefaultProps: ->
    componentName: 'token-input'
    url: ''
    queryParam: 'search[query]'
    withDescription: false
    allowCreation: null
  componentDidMount: ->
    #refactor this so we can include a function that return the element
    if @props.withDescription
      formater = (item) ->
        return "<li> #{item.name} <p> #{item.description} </p> </li>"
    else
      formater = (item) ->
        return "<li> #{item.name} </li>"

    state = @
    $("#" + state.props.componentName).tokenInput(state.props.url, {
      crossDomain: false,
      theme: "facebook"
      hintText: "Escriba su busqueda"
      allowCreation: @props.allowCreation
      queryParam: state.props.queryParam
      tokenLimit: 1
      searchingText: "Buscando..."
      noResultsText: "No se encontro"
      resultsFormatter: formater
      onAdd: (item) ->
        state.props.onAddToken item
      onDelete: (item) ->
        state.props.onRemoveToken item
    })
  render: ->
    React.DOM.div
      className: 'form-group token-input '
      React.DOM.input
        type: 'text'
        className: 'form-control'
        id: @props.componentName
        placeholder: @props.componentName
        ref: @props.componentName
        name: @props.componentName


