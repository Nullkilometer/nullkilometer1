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

ActiveRecord::Schema.define(version: 2015_11_12_114809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "deliveries", id: :serial, force: :cascade do |t|
    t.integer "point_of_production_id"
    t.integer "product_id"
    t.float "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["point_of_production_id"], name: "index_deliveries_on_point_of_production_id"
    t.index ["product_id"], name: "index_deliveries_on_product_id"
  end

  create_table "detail_infos", id: :serial, force: :cascade do |t|
    t.string "website"
    t.string "mail"
    t.string "phone"
    t.string "cell_phone"
    t.text "description"
    t.string "detailable_type"
    t.integer "detailable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "image"
  end

  create_table "market_stalls", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "point_of_sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "status_id"
    t.index ["point_of_sale_id"], name: "index_market_stalls_on_point_of_sale_id"
  end

  create_table "opening_times", id: :serial, force: :cascade do |t|
    t.integer "point_of_sale_id"
    t.integer "day"
    t.string "from"
    t.string "to"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["point_of_sale_id"], name: "index_opening_times_on_point_of_sale_id"
  end

  create_table "place_features", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "place_features_point_of_interests", id: false, force: :cascade do |t|
    t.integer "place_feature_id"
    t.integer "point_of_interest_id"
  end

  create_table "point_of_interests", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.float "lat"
    t.float "lon"
    t.integer "pos_type"
    t.string "type"
    t.integer "status_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", id: :serial, force: :cascade do |t|
    t.integer "category"
    t.string "seller_type"
    t.integer "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.string "name"
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

end
