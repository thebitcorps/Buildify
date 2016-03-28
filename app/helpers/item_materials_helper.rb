module ItemMaterialsHelper
  def map_status(item_material)
    if item_material.partially?
      "Solo se entrego #{item_material.received} #{item_material.measure_unit}"
    elsif item_material.authorize?
      'Esperando al proveedor'
    elsif item_material.missed?
      'No fue entregado'
    elsif item_material.deliver?
      'Fue entregado completamente'
    elsif item_material.pending?
      'Esperando orden de compra'
    else
      'Otro'
    end

  end
end
