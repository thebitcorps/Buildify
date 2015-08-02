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

ActiveRecord::Schema.define(version: 20150802003601) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "constructions", force: :cascade do |t|
    t.string   "title"
    t.date     "start_date"
    t.date     "finish_date"
    t.decimal  "contract_amount"
    t.decimal  "current_amount"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.string   "concept"
    t.string   "status"
    t.decimal  "amount_paid"
    t.string   "payment_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "invoice_receipts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "folio"
    t.decimal  "amount"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "provider_id"
    t.integer  "expense_id"
    t.integer  "invoice_receipt_id"
  end

  add_index "invoices", ["expense_id"], name: "index_invoices_on_expense_id", using: :btree
  add_index "invoices", ["invoice_receipt_id"], name: "index_invoices_on_invoice_receipt_id", using: :btree
  add_index "invoices", ["provider_id"], name: "index_invoices_on_provider_id", using: :btree

  create_table "item_materials", force: :cascade do |t|
    t.decimal  "requested"
    t.decimal  "recived"
    t.string   "status"
    t.decimal  "quiantity"
    t.decimal  "unit_price"
    t.integer  "requisition_id"
    t.integer  "purchase_order_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "material_id"
  end

  add_index "item_materials", ["material_id"], name: "index_item_materials_on_material_id", using: :btree
  add_index "item_materials", ["purchase_order_id"], name: "index_item_materials_on_purchase_order_id", using: :btree
  add_index "item_materials", ["requisition_id"], name: "index_item_materials_on_requisition_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "measure_unit"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "telephone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "folio"
    t.string   "delivery_place"
    t.string   "delivery_address"
    t.string   "delivery_receiver"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "invoice_id"
  end

  add_index "purchase_orders", ["invoice_id"], name: "index_purchase_orders_on_invoice_id", using: :btree

  create_table "requisitions", force: :cascade do |t|
    t.integer  "folio"
    t.integer  "construction_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "requisitions", ["construction_id"], name: "index_requisitions_on_construction_id", using: :btree

  add_foreign_key "invoices", "expenses"
  add_foreign_key "invoices", "invoice_receipts"
  add_foreign_key "invoices", "providers"
  add_foreign_key "item_materials", "materials"
  add_foreign_key "item_materials", "purchase_orders"
  add_foreign_key "item_materials", "requisitions"
  add_foreign_key "purchase_orders", "invoices"
  add_foreign_key "requisitions", "constructions"
end
