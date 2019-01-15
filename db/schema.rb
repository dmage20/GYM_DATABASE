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

ActiveRecord::Schema.define(version: 2019_01_10_061430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "gym_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gym_id"], name: "index_admins_on_gym_id"
    t.index ["user_id"], name: "index_admins_on_user_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.integer "total_price"
    t.date "start_date"
    t.date "end_date"
    t.string "status", default: "Pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "gym_id"
    t.index ["gym_id"], name: "index_bookings_on_gym_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.boolean "bookmarked", default: false
    t.bigint "user_id"
    t.bigint "gym_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gym_id"], name: "index_bookmarks_on_gym_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gyms_count", default: 0, null: false
    t.string "state"
    t.index ["country_id"], name: "index_cities_on_country_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "gyms_count", default: 0, null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.datetime "start"
    t.datetime "end"
    t.string "color"
    t.bigint "gym_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gym_id"], name: "index_events_on_gym_id"
  end

  create_table "gyms", force: :cascade do |t|
    t.bigint "country_id"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "address"
    t.float "latitude"
    t.float "longitude"
    t.string "website"
    t.string "username"
    t.string "igplace"
    t.string "hashtag"
    t.index ["city_id"], name: "index_gyms_on_city_id"
    t.index ["country_id"], name: "index_gyms_on_country_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "conversation_id"
    t.bigint "user_id"
    t.boolean "read", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "content"
    t.bigint "gym_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["gym_id"], name: "index_reviews_on_gym_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "scores", force: :cascade do |t|
    t.bigint "wod_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.datetime "time"
    t.bigint "gym_id"
    t.index ["gym_id"], name: "index_scores_on_gym_id"
    t.index ["user_id"], name: "index_scores_on_user_id"
    t.index ["wod_id"], name: "index_scores_on_wod_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "whiteboards", force: :cascade do |t|
    t.bigint "gym_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gym_id"], name: "index_whiteboards_on_gym_id"
  end

  create_table "wods", force: :cascade do |t|
    t.text "instructions"
    t.text "body"
    t.datetime "date"
    t.bigint "gym_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["gym_id"], name: "index_wods_on_gym_id"
    t.index ["user_id"], name: "index_wods_on_user_id"
  end

  add_foreign_key "admins", "gyms"
  add_foreign_key "admins", "users"
  add_foreign_key "bookings", "gyms"
  add_foreign_key "bookings", "users"
  add_foreign_key "bookmarks", "gyms"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "cities", "countries"
  add_foreign_key "events", "gyms"
  add_foreign_key "gyms", "cities"
  add_foreign_key "gyms", "countries"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "reviews", "gyms"
  add_foreign_key "reviews", "users"
  add_foreign_key "scores", "gyms"
  add_foreign_key "scores", "users"
  add_foreign_key "scores", "wods"
  add_foreign_key "whiteboards", "gyms"
  add_foreign_key "wods", "gyms"
  add_foreign_key "wods", "users"
end
