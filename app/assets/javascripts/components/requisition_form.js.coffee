@RequisitionForm = React.createClass
  getInitialState: ->
    itemMaterials: []
    errors: []
    itemMaterialsIdCount: 0
  getDefaultProps: ->
    itemMaterials: []
    errors: []
  #funtion for inputs that update the state with a given value and the name of the object in the state
  valid: ->
    @state.requisition_date
  # update the state with the name of the input
  handleInputChange: (name,value) ->
    @setState "#{name}": value
  # finds a change
  handleUpdateItemMaterial: (old,new_item) ->
    index = @state.itemMaterials.indexOf old
    itemMaterials = @state.itemMaterials.slice()
    itemMaterials.splice index,1 , new_item
    @setState itemMaterials: itemMaterials
  # push a new item material to the stateand add 1 to the count
  addNewItemMaterial: (element)->
    element.id = @state.itemMaterialsIdCount
    itemMaterials = @state.itemMaterials.slice()
    itemMaterials.push element
    @setState {itemMaterials: itemMaterials,itemMaterialsIdCount: @state.itemMaterialsIdCount + 1 }
  deleteItemMaterial: (element) ->
    itemMaterials = @state.itemMaterials.slice()
    index = itemMaterials.indexOf element
    itemMaterials.splice index,1
    @setState {itemMaterials: itemMaterials,itemMaterialsIdCount: @state.itemMaterialsIdCount - 1}
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
      success:  (data)->
        #update the browers window
        window.location.replace('/requisitions/' + data.id)
        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)

  render: ->
    React.DOM.div
      className: 'requisition-form'
      React.createElement ErrorBox, errorsArray: @state.errors
      React.createElement LabelInput,label: 'Requisition Date',placeholder: 'Date',name: 'requisition_date',changed: @handleInputChange
      React.createElement ItemMaterialForm, handleNewItemMaterial: @addNewItemMaterial
      React.DOM.table
        className: 'table table-striped'
        React.DOM.thead null,
          React.DOM.tr null,
            for th,i in ['Material','Requsested','']
              React.DOM.th key: i,th
        React.DOM.tbody null,
          for itemMaterial in @state.itemMaterials
            React.createElement ItemMaterial,itemMaterial: itemMaterial,handleDeleteItemMaterial: @deleteItemMaterial,key: itemMaterial.id,handleUpdate: @handleUpdateItemMaterial
      React.DOM.button
        className: 'btn btn-primary'
        onClick: @handleSubmit
        disabled: !@valid()
        'Submit'