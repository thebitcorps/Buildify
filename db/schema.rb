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

ActiveRecord::Schema.define(version: 20150731200825) do

  create_table "constructions", force: :cascade do |t|
    t.string   "title",           limit: 255
    t.date     "start_date"
    t.date     "finish_date"
    t.decimal  "contract_amount",             precision: 10
    t.decimal  "current_amount",              precision: 10
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  create_table "item_materials", force: :cascade do |t|
    t.decimal  "requested",                     precision: 10
    t.decimal  "recived",                       precision: 10
    t.string   "status",            limit: 255
    t.decimal  "quiantity",                     precision: 10
    t.decimal  "unit_price",                    precision: 10
    t.integer  "requisition_id",    limit: 4
    t.integer  "purchase_order_id", limit: 4
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "item_materials", ["purchase_order_id"], name: "index_item_materials_on_purchase_order_id", using: :btree
  add_index "item_materials", ["requisition_id"], name: "index_item_materials_on_requisition_id", using: :btree

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "folio",             limit: 4
    t.string   "delivery_place",    limit: 255
    t.string   "delivery_address",  limit: 255
    t.string   "delivery_receiver", limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "requisitions", force: :cascade do |t|
    t.integer  "folio",           limit: 4
    t.integer  "construction_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "requisitions", ["construction_id"], name: "index_requisitions_on_construction_id", using: :btree

  add_foreign_key "item_materials", "purchase_orders"
  add_foreign_key "item_materials", "requisitions"
  add_foreign_key "requisitions", "constructions"
end
