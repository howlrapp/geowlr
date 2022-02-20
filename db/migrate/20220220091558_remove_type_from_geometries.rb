class RemoveTypeFromGeometries < ActiveRecord::Migration[6.0]
  def change
    remove_column :geometries, :type
  end
end
