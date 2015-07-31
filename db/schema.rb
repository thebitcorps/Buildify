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

ActiveRecord::Schema.define(version: 20150731200257) do

  create_table "constructions", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.date     "start_date"
    t.date     "finish_date"
    t.decimal  "contract_amount",             precision: 10
    t.decimal  "current_amount",              precision: 10
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "folio",             limit: 4
    t.string   "delivery_place",    limit: 255
    t.string   "delivery_address",  limit: 255
    t.string   "delivery_receiver", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "remissions", force: :cascade do |t|
    t.string   "remission_date",  limit: 255
    t.integer  "construction_id", limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "remissions", ["construction_id"], name: "index_remissions_on_construction_id", using: :btree

  create_table "requisitions", force: :cascade do |t|
    t.integer  "construction_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "requisitions", ["construction_id"], name: "index_requisitions_on_construction_id", using: :btree

  add_foreign_key "remissions", "constructions"
  add_foreign_key "requisitions", "constructions"
end
