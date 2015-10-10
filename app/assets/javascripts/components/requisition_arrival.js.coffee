@RequisitionArrival = React.createClass
  getInitialState: ->
    itemMaterials: @props.itemMaterials
  itemMaterialUpdate: (itemId,newStatus)->
    items = @state.itemMaterials.slice()
    for itemMaterial in items
      if itemMaterial.id == parseInt itemId,10
        itemMaterial.status = newStatus
        @setState itemMaterials: items
        return
  render: ->
    React.DOM.div
      className: 'requisition-arrival'
      React.DOM.div
        className: 'panel panel-default'
        React.DOM.table
          className: 'table'
          React.DOM.thead null,
            #maye remove the Estado th and left only the actions
            for th,index in ['Material','Pedido','Orden de Compra','Actions']
              React.DOM.th key: index,th
          React.DOM.tbody null,
            for itemMaterial in @state.itemMaterials
              React.createElement ItemMaterialArrival,key: itemMaterial.id,itemMaterial: itemMaterial,itemMaterialChanged: @itemMaterialUpdate
