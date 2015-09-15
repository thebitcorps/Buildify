@RequisitionForm = React.createClass
  getInitialState: ->
    itemMaterials: []
    errors: []
    itemMaterialsIdCount: 0
  getDefaultProps: ->
    itemMaterials: []
    errors: []
  handleInputChange: (name,value) ->
    @setState "#{name}": value
  handleUpdateItemMaterial: (old,new_item) ->
    index = @state.itemMaterials.indexOf old
    itemMaterials = @state.itemMaterials.slice()
    itemMaterials.splice index,1 , new_item
    @setState itemMaterials: itemMaterials
  addNewItemMaterial: (element)->
    element.id = @state.itemMaterialsIdCount
    itemMaterials = @state.itemMaterials.slice()
    itemMaterials.push element
    @setState itemMaterialsIdCount: @state.itemMaterialsIdCount + 1
    @setState itemMaterials: itemMaterials
  deleteItemMaterial: (element) ->
    itemMaterials = @state.itemMaterials.slice()
    index = itemMaterials.indexOf element
    itemMaterials.splice index,1
    @setState itemMaterials: itemMaterials
  handleSubmit: (e) ->
    e.preventDefault()
    data =
      requisition_date: @state.requisition_date
      construction_id: @props.construction_id
      item_materials_attributes: @state.itemMaterials
    that = @
    $.ajax
      url: '/requisitions.json'
      type: 'POST'
      data: {requisition: data}
      dataType: 'JSON'
      success:  ->
        window.location.replace('/constructions/' + that.props.construction_id)
        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        that.setState errors: XMLHttpRequest.responseText
        alert XMLHttpRequest.responseText
        return
  render: ->
    React.DOM.div
      className: 'requisition-form'
#      React.createElement ErrorBox, errorsArray: @state.errors
      React.createElement LabelInput,label: 'Requisition Date',placeholder: 'Date',name: 'requisition_date',changed: @handleInputChange
      React.createElement ItemMaterialForm, handleNewItemMaterial: @addNewItemMaterial
      React.DOM.table
        className: 'table table-striped'
        React.DOM.thead null,
          React.DOM.tr null,
            for th,i in ['Material','Requsested','Mesure unit','']
              React.DOM.th key: i,th
        React.DOM.tbody null,
          for itemMaterial in @state.itemMaterials
            React.createElement ItemMaterial,itemMaterial: itemMaterial,handleDeleteItemMaterial: @deleteItemMaterial,key: itemMaterial.id,handleUpdate: @handleUpdateItemMaterial
      React.DOM.button
        className: 'btn btn-primary'
        onClick: @handleSubmit
        'Submit'