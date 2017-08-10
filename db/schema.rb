# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170810180756) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "intersections", force: :cascade do |t|
    t.decimal  "latitude",   precision: 10, scale: 6, null: false
    t.decimal  "longitude",  precision: 10, scale: 6, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "intersections", ["latitude"], name: "index_intersections_on_latitude", using: :btree
  add_index "intersections", ["longitude"], name: "index_intersections_on_longitude", using: :btree

  create_table "road_edges", force: :cascade do |t|
    t.integer  "intersection1_id", null: false
    t.integer  "intersection2_id", null: false
    t.string   "street_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "road_edges", ["intersection1_id"], name: "index_road_edges_on_intersection1_id", using: :btree
  add_index "road_edges", ["intersection2_id"], name: "index_road_edges_on_intersection2_id", using: :btree
  add_index "road_edges", ["street_name"], name: "index_road_edges_on_street_name", using: :btree

  create_table "road_points", force: :cascade do |t|
    t.decimal "latitude",     precision: 10, scale: 6, null: false
    t.decimal "longitude",    precision: 10, scale: 6, null: false
    t.integer "road_edge_id",                          null: false
  end

  add_index "road_points", ["latitude"], name: "index_road_points_on_latitude", using: :btree
  add_index "road_points", ["longitude"], name: "index_road_points_on_longitude", using: :btree

end
