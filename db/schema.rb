# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_02_102002) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "geometries", force: :cascade do |t|
    t.string "reference"
    t.json "properties"
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.geometry "geom", limit: {:srid=>4326, :type=>"multi_polygon"}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", default: "Locality", null: false
    t.string "cached_name"
    t.jsonb "cached_hierarchy", default: {}
    t.index "to_tsvector('english'::regconfig, cached_hierarchy)", name: "index_geometries_on_cached_hierarchy", using: :gist
    t.index ["geom"], name: "index_geometries_on_geom", using: :gist
    t.index ["lonlat"], name: "index_geometries_on_lonlat", using: :gist
    t.index ["reference"], name: "index_geometries_on_reference"
    t.index ["type"], name: "index_geometries_on_type"
  end

end
