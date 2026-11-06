# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_11_03_205200) do
  create_table "activities", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_activities_on_name", unique: true
  end

  create_table "parks", force: :cascade do |t|
    t.integer "region_id", null: false
    t.string "name", null: false
    t.string "park_type", null: false
    t.text "description", null: false
    t.string "website_url"
    t.string "source_name", null: false
    t.boolean "accessible", default: false, null: false
    t.decimal "latitude", precision: 9, scale: 6, null: false
    t.decimal "longitude", precision: 9, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id", "name"], name: "index_parks_on_region_id_and_name", unique: true
    t.index ["region_id"], name: "index_parks_on_region_id"
  end

  create_table "regions", force: :cascade do |t|
    t.string "name", null: false
    t.string "province", default: "Ontario", null: false
    t.string "country", default: "Canada", null: false
    t.string "source_name", null: false
    t.decimal "latitude", precision: 9, scale: 6, null: false
    t.decimal "longitude", precision: 9, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_regions_on_name", unique: true
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "trail_activities", force: :cascade do |t|
    t.integer "trail_id", null: false
    t.integer "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_trail_activities_on_activity_id"
    t.index ["trail_id", "activity_id"], name: "index_trail_activities_on_trail_id_and_activity_id", unique: true
    t.index ["trail_id"], name: "index_trail_activities_on_trail_id"
  end

  create_table "trail_tags", force: :cascade do |t|
    t.integer "trail_id", null: false
    t.integer "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_trail_tags_on_tag_id"
    t.index ["trail_id", "tag_id"], name: "index_trail_tags_on_trail_id_and_tag_id", unique: true
    t.index ["trail_id"], name: "index_trail_tags_on_trail_id"
  end

  create_table "trails", force: :cascade do |t|
    t.integer "park_id", null: false
    t.string "name", null: false
    t.text "description", null: false
    t.string "difficulty", null: false
    t.string "surface", null: false
    t.decimal "distance_km", precision: 6, scale: 2, null: false
    t.integer "elevation_gain_m", default: 0, null: false
    t.string "source_name", null: false
    t.decimal "latitude", precision: 9, scale: 6, null: false
    t.decimal "longitude", precision: 9, scale: 6, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["difficulty"], name: "index_trails_on_difficulty"
    t.index ["park_id", "name"], name: "index_trails_on_park_id_and_name", unique: true
    t.index ["park_id"], name: "index_trails_on_park_id"
  end

  add_foreign_key "parks", "regions"
  add_foreign_key "trail_activities", "activities"
  add_foreign_key "trail_activities", "trails"
  add_foreign_key "trail_tags", "tags"
  add_foreign_key "trail_tags", "trails"
  add_foreign_key "trails", "parks"
end
