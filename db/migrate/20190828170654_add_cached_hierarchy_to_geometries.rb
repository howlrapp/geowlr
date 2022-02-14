class AddCachedHierarchyToGeometries < ActiveRecord::Migration[5.2]
  def change
    add_column :geometries, :cached_hierarchy, :string, array: true, default: []
  end
end
