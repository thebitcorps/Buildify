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

ActiveRecord::Schema.define(version: 20150820045810) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billing_adjustments", force: :cascade do |t|
    t.decimal  "amount"
    t.string   "payment_type"
    t.date     "adjusment_date"
    t.integer  "payment_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "billing_adjustments", ["payment_id"], name: "index_billing_adjustments_on_payment_id", using: :btree

  create_table "constructions", force: :cascade do |t|
    t.string   "title"
    t.date     "start_date"
    t.date     "finish_date"
    t.decimal  "contract_amount"
    t.decimal  "estimates_amount", default: 0.0
    t.integer  "user_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "constructions", ["user_id"], name: "index_constructions_on_user_id", using: :btree

  create_table "estimates", force: :cascade do |t|
    t.decimal  "amount"
    t.date     "payment_date"
    t.integer  "construction_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "estimates", ["construction_id"], name: "index_estimates_on_construction_id", using: :btree

  create_table "invoice_receipts", force: :cascade do |t|
    t.integer  "folio"
    t.integer  "receipt_date"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.string   "folio"
    t.string   "concept"
    t.decimal  "amount"
    t.date     "invoice_date"
    t.integer  "invoice_receipt_id"
    t.integer  "payment_id"
    t.integer  "provider_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "invoices", ["invoice_receipt_id"], name: "index_invoices_on_invoice_receipt_id", using: :btree
  add_index "invoices", ["payment_id"], name: "index_invoices_on_payment_id", using: :btree
  add_index "invoices", ["provider_id"], name: "index_invoices_on_provider_id", using: :btree

  create_table "item_materials", force: :cascade do |t|
    t.decimal  "requested"
    t.decimal  "recived"
    t.string   "status"
    t.decimal  "unit_price"
    t.string   "measure_unit"
    t.integer  "requisition_id"
    t.integer  "purchase_order_id"
    t.integer  "material_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "item_materials", ["material_id"], name: "index_item_materials_on_material_id", using: :btree
  add_index "item_materials", ["purchase_order_id"], name: "index_item_materials_on_purchase_order_id", using: :btree
  add_index "item_materials", ["requisition_id"], name: "index_item_materials_on_requisition_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "payments", force: :cascade do |t|
    t.string   "status"
    t.string   "consept"
    t.date     "payment_date"
    t.decimal  "paid_amount"
    t.integer  "construction_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "payments", ["construction_id"], name: "index_payments_on_construction_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.string   "telephone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "folio"
    t.string   "delivery_place"
    t.string   "delivery_address"
    t.string   "delivery_receiver"
    t.integer  "requisition_id"
    t.integer  "invoice_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "purchase_orders", ["invoice_id"], name: "index_purchase_orders_on_invoice_id", using: :btree
  add_index "purchase_orders", ["requisition_id"], name: "index_purchase_orders_on_requisition_id", using: :btree

  create_table "requisitions", force: :cascade do |t|
    t.integer  "folio"
    t.date     "requisition_date"
    t.integer  "construction_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "requisitions", ["construction_id"], name: "index_requisitions_on_construction_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "role"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "billing_adjustments", "payments"
  add_foreign_key "constructions", "users"
  add_foreign_key "estimates", "constructions"
  add_foreign_key "invoices", "invoice_receipts"
  add_foreign_key "invoices", "payments"
  add_foreign_key "invoices", "providers"
  add_foreign_key "item_materials", "materials"
  add_foreign_key "item_materials", "purchase_orders"
  add_foreign_key "item_materials", "requisitions"
  add_foreign_key "payments", "constructions"
  add_foreign_key "purchase_orders", "invoices"
  add_foreign_key "purchase_orders", "requisitions"
  add_foreign_key "requisitions", "constructions"
end
