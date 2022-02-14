class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    rename_table :localities, :geometries
    add_column :geometries, :type, :string, default: "Locality", null: false, index: true
  end
end
