@PurchaseOrder = React.createClass
  getInitialState: ->
    purchaseOrder: @props.purchaseOrder
  onTokenAdded: (item) ->
    @setState provider_id_hidden: item.id
    @setState provider_name_hidden: item.name
    @setState provider_address: item.address
    if @state.delivery_type == 'pick_up'
      @setState delivery_address: item.address
  removeToken: (item) ->
    @setState provider_id_hidden: ''
    @setState provider_name_hidden: ''
    @setState provider_address: ''
    @setState delivery_address: ''
    $("#delivery_place").val('')
  changeDeliveryType: (value)->
    @setState delivery_type: value
    if value == 'ship'
      @setState delivery_address: @props.constructionAddress
    else if value == 'pick_up'
      @setState delivery_address: @state.provider_address
    else
      @setState delivery_address: ''
  handleInputChange: (name,value) ->
    @setState "#{name}": value
  render: ->
    React.DOM.div
      className: 'purchase-order'
      React.DOM.div
        className: 'purchase-form'
        React.createElement TokenInput,componentName: 'provider',url: '/providers.json', onAddToken: @onTokenAdded, onRemoveToken: @removeToken
        React.createElement LabelSelect, label: 'Delivery type',name: 'delivery_place',options: [{'display' : '','value': ''},{'display' : 'Ship','value' : 'ship'},{'display' : 'Pick up', 'value' : 'pick_up'}],onChanged: @changeDeliveryType
        React.createElement LabelInput, label: 'Delivery Address', name: 'delivery_address',changed: @handleInputChange, disabled: true, value: @state.delivery_address
        React.createElement LabelInput, label: 'Delivery recveiver', name: 'delivery_receiver', changed: @handleInputChange
      React.DOM.div
        className: 'purchase-items'
        React.DOM.h2 null, 'Materials'
        React.DOM.ul
          className: 'list-group'
          for itemMaterial in @props.itemMaterials
            React.DOM.li
              className: 'list-group-item'
              key: itemMaterial.id
              React.DOM.h4
                className: 'list-group-item-heading'
                itemMaterial.material.name
                React.DOM.div
                  className: 'pull-right'
                  React.DOM.label
                    className: 'label label-primary'
                    "#{itemMaterial.requested} #{itemMaterial.mesure_unit}"
              React.DOM.p
                className: 'list-group-item-text'
                itemMaterial.material.description
