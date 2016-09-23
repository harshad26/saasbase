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

ActiveRecord::Schema.define(version: 20160923103528) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string   "company_name"
    t.string   "company_address_1"
    t.string   "company_address_2"
    t.string   "company_city"
    t.string   "company_zipcode"
    t.string   "company_country"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "brandings", force: :cascade do |t|
    t.string   "name"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city"
    t.string   "country"
    t.string   "postal_code"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "plans", force: :cascade do |t|
    t.string   "stripe_plan_id"
    t.string   "name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "google_api_key"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "email"
    t.string   "url"
    t.text     "description"
    t.text     "categories"
    t.string   "custom_field_1"
    t.string   "custom_field_2"
    t.string   "custom_field_3"
    t.string   "image_url"
    t.string   "custom_marker_url"
    t.string   "lat"
    t.string   "long"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "account_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "account_id"
    t.string   "stripe_token"
    t.string   "stripe_customer_id"
    t.string   "stripe_subscription_id"
    t.string   "stripe_plan_id"
    t.string   "last_4_digits"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "subscriptions", ["account_id"], name: "index_subscriptions_on_account_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "account_id"
  end

  add_index "users", ["account_id"], name: "index_users_on_account_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "subscriptions", "accounts"
  add_foreign_key "users", "accounts"
end
