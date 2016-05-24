module ItemMaterialsHelper
  # @param [Object] item_material
  def map_status(item_material)
    if item_material.partially?
      "Solo se entrego #{item_material.received} #{item_material.measure_unit}"
    elsif item_material.authorized?
      'Esperando al proveedor'
    elsif item_material.missed?
      'No fue entregado'
    elsif item_material.delivered?
      'Fue entregado completamente'
    elsif item_material.pending?
      'Esperando orden de compra'
    else
      'Otro'
    end

  end

  # @param [Hash] material_hash a hash with count, pending ,authorized ,missed , delivered ,partially values with the count of every item material
  # @return [String] the message pf the status for all the item materials
  def item_materials_status_message(material_hash)
    message = [t('materials.name',count: material_hash[:count])]
    message << t('item_material.pending', count: material_hash[:pending]) if material_hash[:pending] > 0
    message << t('item_material.authorized',count: material_hash[:authorized]) if material_hash[:authorized] > 0
    message << t('item_material.missed',count: material_hash[:missed]) if material_hash[:missed] > 0
    message << t('item_material.delivered',count: material_hash[:delivered]) if material_hash[:delivered] > 0
    message << t('item_material.partially',count: material_hash[:partially]) if material_hash[:partially] > 0
    message.join ', '
  end
end
