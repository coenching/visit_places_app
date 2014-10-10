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

ActiveRecord::Schema.define(version: 20141009190600) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorites", force: true do |t|
    t.integer  "user_id"
    t.integer  "place_id"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorites", ["place_id"], name: "index_favorites_on_place_id", using: :btree
  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id", using: :btree

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.integer  "visit_id"
    t.string   "picture"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["visit_id"], name: "index_photos_on_visit_id", using: :btree

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "gender"
    t.string   "price"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
  end

  create_table "recommendations", force: true do |t|
    t.integer  "user_id"
    t.integer  "visit_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recommendations", ["user_id"], name: "index_recommendations_on_user_id", using: :btree
  add_index "recommendations", ["visit_id"], name: "index_recommendations_on_visit_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture"
  end

  create_table "visits", force: true do |t|
    t.integer  "place_id"
    t.string   "date"
    t.integer  "rating"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "visits", ["place_id"], name: "index_visits_on_place_id", using: :btree
  add_index "visits", ["user_id"], name: "index_visits_on_user_id", using: :btree

end
