class ChangeCachedHierarchyToHstore < ActiveRecord::Migration[5.2]
  def change
    remove_column :geometries, :cached_hierarchy, :string, array: true
    add_column :geometries, :cached_hierarchy, :jsonb, default: {}
  end
end
