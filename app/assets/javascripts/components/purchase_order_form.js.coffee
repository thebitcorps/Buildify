@PurchaseOrderForm = React.createClass
  displayName: 'Purchase order form'
  getInitialState: ->
    purchaseOrder: @props.purchaseOrder
  onTokenAdded: (item) ->
    @setState {provider_id_hidden: item.id,provider_name_hidden: item.name,provider_address: item.description}
    if @state.delivery_type == 'pick_up'
      @setState delivery_address: item.address
    @props.notifyParent {provider_id_hidden: item.id,provider_name_hidden: item.name,provider_address: item.description }
  removeToken: (item) ->
    @setState {provider_id_hidden: '',provider_name_hidden: '',provider_address: '',delivery_address: ''}
    $("#delivery_place").val('')
    @props.notifyParent {provider_id_hidden: '',provider_name_hidden: '',provider_address: '',delivery_address: '',delivery_type: ''}
  changeDeliveryType: (value)->
    @setState delivery_type: value
    @props.notifyParent {delivery_type: value}
    if value == 'ship'
      @props.notifyParent {delivery_address: @props.constructionAddress}
      @setState delivery_address: @props.constructionAddress
    else if value == 'pick_up'
      @props.notifyParent {delivery_address: @state.provider_address}
      @setState delivery_address: @state.provider_address
    else
      @props.notifyParent {delivery_address: ''}
      @setState delivery_address: ''
  handleInputChange: (name,value) ->
    @setState "#{name}": value
    @props.notifyParent {"#{name}": value}
  render: ->
    React.DOM.div
      className: 'purchase-order'
      React.DOM.div
        className: 'purchase-form'
        React.DOM.label {className: ''},'Proveedor'
        React.createElement TokenInput,componentName: 'provider',url: '/providers.json', onAddToken: @onTokenAdded, onRemoveToken: @removeToken,withDescription: true
        React.createElement LabelSelect, label: 'Tipo de entrega',name: 'delivery_place',options: [{'display' : '','value': ''},{'display' : 'Se enviara a obra','value' : 'ship'},{'display' : 'Ir a recoger', 'value' : 'pick_up'}],onChanged: @changeDeliveryType
        React.createElement LabelInput, label: 'Direccion de entrega', name: 'delivery_address',changed: @handleInputChange, disabled: true, value: @state.delivery_address
        React.createElement LabelInput, label: 'Nombre del recibidor', name: 'delivery_receiver', changed: @handleInputChange
