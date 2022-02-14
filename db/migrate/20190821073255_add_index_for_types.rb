class AddIndexForTypes < ActiveRecord::Migration[5.2]
  def change
    add_index :geometries, :type, using: :btree
  end
end
