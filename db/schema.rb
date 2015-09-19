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

ActiveRecord::Schema.define(version: 20150919023305) do

  create_table "items", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.text     "description",         limit: 65535
    t.decimal  "price",                             precision: 5, scale: 3
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.integer  "user_id",             limit: 4
  end

  create_table "meetings", force: :cascade do |t|
    t.string   "time",       limit: 255
    t.boolean  "reserved"
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "duration",   limit: 4
  end

  create_table "recipients", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "email",      limit: 255
    t.string   "zipcode",    limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "recipients", ["email"], name: "index_recipients_on_email", unique: true, using: :btree

  create_table "reservations", force: :cascade do |t|
    t.integer  "user_id",             limit: 4
    t.string   "time",                limit: 255
    t.text     "order",               limit: 65535
    t.decimal  "price",                             precision: 5, scale: 3
    t.boolean  "confimation"
    t.datetime "created_at",                                                                null: false
    t.datetime "updated_at",                                                                null: false
    t.boolean  "sent"
    t.text     "notification_params", limit: 65535
    t.string   "status",              limit: 255
    t.string   "transaction_id",      limit: 255
    t.datetime "purchased_at"
    t.boolean  "paid",                                                      default: false
    t.integer  "sender_id",           limit: 4
    t.integer  "receiver_id",         limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                limit: 255
    t.string   "email",               limit: 255
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
    t.string   "password_digest",     limit: 255
    t.string   "remember_digest",     limit: 255
    t.boolean  "admin",                             default: false
    t.string   "activation_digest",   limit: 255
    t.boolean  "activated",                         default: false
    t.datetime "activated_at"
    t.string   "reset_digest",        limit: 255
    t.datetime "reset_sent_at"
    t.boolean  "chef",                              default: false
    t.string   "avatar_file_name",    limit: 255
    t.string   "avatar_content_type", limit: 255
    t.integer  "avatar_file_size",    limit: 4
    t.datetime "avatar_updated_at"
    t.string   "zipcode",             limit: 255
    t.float    "lat",                 limit: 24
    t.float    "lng",                 limit: 24
    t.string   "food",                limit: 255
    t.text     "messages",            limit: 65535
    t.text     "menu",                limit: 65535
    t.boolean  "request",                           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["lat", "lng"], name: "index_users_on_lat_and_lng", using: :btree

end
