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

ActiveRecord::Schema.define(version: 2021_06_23_144414) do

  create_table "booking_room_availabilities", force: :cascade do |t|
    t.integer "booking_room_id", null: false
    t.date "day"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "price"
    t.index ["booking_room_id"], name: "index_booking_room_availabilities_on_booking_room_id"
  end

  create_table "booking_rooms", force: :cascade do |t|
    t.integer "room_id", null: false
    t.string "title"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "guests"
    t.index ["room_id"], name: "index_booking_rooms_on_room_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "properties_property_options", id: false, force: :cascade do |t|
    t.integer "property_id", null: false
    t.integer "property_option_id", null: false
  end

  create_table "property_options", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "room_options", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "room_options_rooms", id: false, force: :cascade do |t|
    t.integer "room_id", null: false
    t.integer "room_option_id", null: false
  end

  create_table "rooms", force: :cascade do |t|
    t.string "title"
    t.integer "property_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["property_id"], name: "index_rooms_on_property_id"
  end

  add_foreign_key "booking_room_availabilities", "booking_rooms"
  add_foreign_key "booking_rooms", "rooms"
  add_foreign_key "rooms", "properties"
end
