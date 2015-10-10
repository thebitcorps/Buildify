@ItemMaterialArrival = React.createClass
  getInitialState: ->
    status: @props.itemMaterial.status
    rowColor: @getRowColor @props.itemMaterial.status
  getRowColor: (status) ->
    if @props.itemMaterial.purchase_order_id == null
      return 'default'
    if status == 'missed'
      return 'danger'
    else if status == 'delivered'
      return 'success'
    else if status == 'partially'
      return 'warning'
    else
      return 'dafault'
  radioChanged: (name,value) ->
    @setState {status: value,rowColor: @getRowColor(value)}
    @props.itemMaterialChanged name,value

    that= @
    id =  that.props.itemMaterial.id
    $.ajax
      type: 'PUT'
      url: '/item_materials/'+ id
      data: {item_material: {status: value}}
      dataType: 'JSON'
      success:  (data) ->

        return
      error: (XMLHttpRequest, textStatus, errorThrown) ->
        #we parse the responses o errors so we can send a array of errors
        if errorThrown == 'Internal Server Error'
          that.setState errors: ['Internal Server Error']
          return
        that.setState errors: $.parseJSON(XMLHttpRequest.responseText)
        return
  render: ->
    React.DOM.tr
      className: @state.rowColor
      React.DOM.td null,
        React.DOM.a
          href: '/materials/' + @props.itemMaterial.material.id
          @props.itemMaterial.material.name
      React.DOM.td null,
        @props.itemMaterial.requested + ' ' + @props.itemMaterial.measure_unit
      React.DOM.td null,
        if @props.itemMaterial.purchase_order_id == null
          'No asignado'
        else
          React.DOM.a
            href: '/purchase_orders/' + @props.itemMaterial.purchase_order_id
            "Orden - #{@props.itemMaterial.purchase_order_id}"
      if @props.itemMaterial.purchase_order_id == null
        React.DOM.td null,
          'Orden de compra no a sido generada'
      else
        React.DOM.td null,
          React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'delivered',label: 'delivered',changed: @radioChanged,checked: @state.status == 'delivered'
          React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'partially',label: 'partially',changed: @radioChanged,checked: @state.status == 'partially'
          React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'missed',label: 'missed',changed: @radioChanged,checked: @state.status == 'missed'
          React.createElement LabelRadio, name: "#{@props.itemMaterial.id}",value: 'authorized',label: 'authorized',changed: @radioChanged,checked: @state.status == 'authorized'

