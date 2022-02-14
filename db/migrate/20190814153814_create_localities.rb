class CreateLocalities < ActiveRecord::Migration[5.2]
  def change
    enable_extension"postgis"
    create_table :localities do |t|
      t.string :reference, index: true, uniq: true
      
      t.json :properties

      t.st_point :lonlat, geographic: true, srid: 4326
      t.index :lonlat, using: :gist

      t.multi_polygon :geom, :srid => 4326
      t.index :geom, using: :gist
      
      t.timestamps
    end
  end
end
