#NESESARY props.divideItemMaterial: funtion that notify parent that item material will be divide
#props.can_cplit: if true will show button that open modal to split the itemMaterial default: false
@ItemMaterialPurchaseOrder = React.createClass
  getDefaultProps: ->
    divideDeafault =
#    handleSelectDefaul = ->
    can_split: false
    divideItemMaterial:  ->
      alert 'Missing default prop divideItemMaterial'
    handleSelect: ->
      return

  getInitialState: ->
    itemMaterial: @props.itemMaterial
    selected: false
  itemCheck: (e) ->
    return unless @props.can_select
#    we send the !@state.selected for some reason in handleSelect the state is no set already
    @props.handleSelect @state.itemMaterial
  divideItemMaterial: (e) ->
    e.stopPropagation()
    @props.divideItemMaterial @props.itemMaterial
  render: ->
    #||||||||ItemMaterial||||||||
    React.DOM.a
      className: "list-group-item  #{'disabled' if !@props.can_select}"
      onClick: @itemCheck
      React.DOM.h4
        className: 'list-group-item-heading'
        @props.itemMaterial.material.name
        React.DOM.div
          className: 'pull-right'
          React.DOM.label
            className: 'label label-primary '
            "#{@props.itemMaterial.requested} #{@props.itemMaterial.measure_unit}"
      React.DOM.p
        className: 'list-group-item-text'
        @props.itemMaterial.material.description
        if @props.can_split
          React.DOM.span
            className: 'pull-right'
            React.DOM.button
              className: 'btn btn-primary btn-xs'
              onClick: @divideItemMaterial
              'Dividir diferencia'
