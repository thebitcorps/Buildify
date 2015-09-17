@ItemMaterialPurchaseOrder = React.createClass
  getInitialState: ->
    itemMaterial: @props.itemMaterial
    selected: false
  itemCheck: (e) ->
    return unless @props.can_select
    @setState selected: !@state.selected
#    we send the !@state.selected for some reason in handleSelect the state is no set already
    @props.handleSelect @state.itemMaterial,!@state.selected
  render: ->
    React.DOM.a
      className: "list-group-item #{'active' if @state.selected} #{'disabled' if !@props.can_select}"
      onClick: @itemCheck
      React.DOM.h4
        className: 'list-group-item-heading'
        @state.itemMaterial.material.name
        React.DOM.div
          className: 'pull-right'
          React.DOM.label
            className: 'label label-default '
            "#{@state.itemMaterial.requested} #{@state.itemMaterial.mesure_unit}"
      React.DOM.p
        className: 'list-group-item-text'
        @state.itemMaterial.material.description
