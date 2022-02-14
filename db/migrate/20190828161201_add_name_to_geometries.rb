class AddNameToGeometries < ActiveRecord::Migration[5.2]
  def change
    add_column :geometries, :cached_name, :string
  end
end
