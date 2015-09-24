@PurchaseOrderForm = React.createClass
  getInitialState: ->
    purchaseOrder: @props.purchaseOrder
  onTokenAdded: (item) ->
    @setState {provider_id_hidden: item.id,provider_name_hidden: item.name,provider_address: item.address}
    if @state.delivery_type == 'pick_up'
      @setState delivery_address: item.address
    @props.notifyParent 'provider_id_hidden',item.id
    @props.notifyParent 'provider_name_hidden', item.name
    @props.notifyParent 'provider_address', item.address
  removeToken: (item) ->
    @setState {provider_id_hidden: '',provider_name_hidden: '',provider_address: '',delivery_address: ''}
    $("#delivery_place").val('')
    @props.notifyParent 'provider_id_hidden',''
    @props.notifyParent 'provider_name_hidden',''
    @props.notifyParent 'provider_address', ''
    @props.notifyParent 'delivery_address',''
    @props.notifyParent 'delivery_type',''
  changeDeliveryType: (value)->
    @setState delivery_type: value
    @props.notifyParent 'delivery_type',value
    if value == 'ship'
      @props.notifyParent 'delivery_address',@props.constructionAddress
      @setState delivery_address: @props.constructionAddress
    else if value == 'pick_up'
      @props.notifyParent 'delivery_address',@state.provider_address
      @setState delivery_address: @state.provider_address
    else
      @props.notifyParent 'delivery_address',''
      @setState delivery_address: ''
  handleInputChange: (name,value) ->
    @setState "#{name}": value
    @props.notifyParent "#{name}",value

  render: ->
    React.DOM.div
      className: 'purchase-order'
      React.DOM.div
        className: 'purchase-form'
        React.createElement TokenInput,componentName: 'provider',url: '/providers.json', onAddToken: @onTokenAdded, onRemoveToken: @removeToken
        React.createElement LabelSelect, label: 'Delivery type',name: 'delivery_place',options: [{'display' : '','value': ''},{'display' : 'Ship','value' : 'ship'},{'display' : 'Pick up', 'value' : 'pick_up'}],onChanged: @changeDeliveryType
        React.createElement LabelInput, label: 'Delivery Address', name: 'delivery_address',changed: @handleInputChange, disabled: true, value: @state.delivery_address
        React.createElement LabelInput, label: 'Delivery recveiver', name: 'delivery_receiver', changed: @handleInputChange
