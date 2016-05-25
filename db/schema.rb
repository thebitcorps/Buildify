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

ActiveRecord::Schema.define(version: 20160525135027) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type", using: :btree
  add_index "activities", ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type", using: :btree
  add_index "activities", ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type", using: :btree

  create_table "billing_adjustments", force: :cascade do |t|
    t.decimal  "amount"
    t.string   "payment_type"
    t.date     "adjustment_date"
    t.integer  "payment_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "folio"
    t.string   "reference"
    t.string   "account"
  end

  add_index "billing_adjustments", ["payment_id"], name: "index_billing_adjustments_on_payment_id", using: :btree

  create_table "construction_users", force: :cascade do |t|
    t.integer  "construction_id"
    t.integer  "user_id"
    t.string   "role"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "construction_users", ["construction_id"], name: "index_construction_users_on_construction_id", using: :btree
  add_index "construction_users", ["user_id"], name: "index_construction_users_on_user_id", using: :btree

  create_table "constructions", force: :cascade do |t|
    t.string   "title"
    t.date     "start_date"
    t.date     "finish_date"
    t.string   "address"
    t.string   "status",           default: "running"
    t.decimal  "contract_amount"
    t.decimal  "estimates_amount", default: 0.0
    t.integer  "user_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "type"
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

  create_table "extensions", force: :cascade do |t|
    t.date     "date"
    t.integer  "construction_id"
    t.decimal  "amount"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "extensions", ["construction_id"], name: "index_extensions_on_construction_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.string   "folio"
    t.string   "status",       default: "waiting"
    t.decimal  "amount"
    t.date     "invoice_date"
    t.integer  "payment_id"
    t.integer  "provider_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "invoices", ["payment_id"], name: "index_invoices_on_payment_id", using: :btree
  add_index "invoices", ["provider_id"], name: "index_invoices_on_provider_id", using: :btree

  create_table "item_materials", force: :cascade do |t|
    t.decimal  "requested"
    t.decimal  "received"
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

  create_table "measure_units", force: :cascade do |t|
    t.string   "unit"
    t.string   "abbreviation"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean  "seen",        default: false
    t.integer  "user_id"
    t.integer  "activity_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "notifications", ["activity_id"], name: "index_notifications_on_activity_id", using: :btree
  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.string   "status",          default: "due"
    t.string   "concept"
    t.decimal  "amount"
    t.date     "payment_date"
    t.decimal  "paid_amount",     default: 0.0
    t.integer  "construction_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "payments", ["construction_id"], name: "index_payments_on_construction_id", using: :btree

  create_table "permitted_measure_units", force: :cascade do |t|
    t.integer  "material_id"
    t.integer  "measure_unit_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "permitted_measure_units", ["material_id"], name: "index_permitted_measure_units_on_material_id", using: :btree
  add_index "permitted_measure_units", ["measure_unit_id"], name: "index_permitted_measure_units_on_measure_unit_id", using: :btree

  create_table "petty_cash_expenses", force: :cascade do |t|
    t.string   "concept"
    t.string   "amount"
    t.date     "expense_date"
    t.text     "observation"
    t.integer  "petty_cash_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "petty_cash_expenses", ["petty_cash_id"], name: "index_petty_cash_expenses_on_petty_cash_id", using: :btree

  create_table "petty_cashes", force: :cascade do |t|
    t.date     "closing_date"
    t.integer  "construction_id"
    t.string   "amount"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "petty_cashes", ["construction_id"], name: "index_petty_cashes_on_construction_id", using: :btree

  create_table "providers", force: :cascade do |t|
    t.string   "name"
    t.string   "telephone"
    t.string   "email"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "zipcode",      default: ""
    t.string   "street",       default: ""
    t.string   "neighborhood", default: ""
    t.string   "number",       default: ""
    t.string   "city",         default: ""
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.integer  "folio"
    t.string   "delivery_place"
    t.string   "delivery_address"
    t.string   "delivery_receiver"
    t.string   "status",            default: "pending"
    t.integer  "requisition_id"
    t.integer  "invoice_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.string   "stamp"
    t.integer  "authorizer_id"
    t.date     "stamp_date"
  end

  add_index "purchase_orders", ["invoice_id"], name: "index_purchase_orders_on_invoice_id", using: :btree
  add_index "purchase_orders", ["requisition_id"], name: "index_purchase_orders_on_requisition_id", using: :btree

  create_table "requisitions", force: :cascade do |t|
    t.integer  "folio"
    t.date     "requisition_date"
    t.string   "status",           default: "pending"
    t.integer  "construction_id"
    t.integer  "user_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "requisitions", ["construction_id"], name: "index_requisitions_on_construction_id", using: :btree
  add_index "requisitions", ["user_id"], name: "index_requisitions_on_user_id", using: :btree

  create_table "royce_connector", force: :cascade do |t|
    t.integer  "roleable_id",   null: false
    t.string   "roleable_type", null: false
    t.integer  "role_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "royce_connector", ["role_id"], name: "index_royce_connector_on_role_id", using: :btree
  add_index "royce_connector", ["roleable_id", "roleable_type"], name: "index_royce_connector_on_roleable_id_and_roleable_type", using: :btree

  create_table "royce_role", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "royce_role", ["name"], name: "index_royce_role_on_name", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "phone"
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
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "billing_adjustments", "payments"
  add_foreign_key "construction_users", "constructions"
  add_foreign_key "construction_users", "users"
  add_foreign_key "constructions", "users"
  add_foreign_key "estimates", "constructions"
  add_foreign_key "extensions", "constructions"
  add_foreign_key "invoices", "payments"
  add_foreign_key "invoices", "providers"
  add_foreign_key "item_materials", "materials"
  add_foreign_key "item_materials", "purchase_orders"
  add_foreign_key "item_materials", "requisitions"
  add_foreign_key "notifications", "activities"
  add_foreign_key "notifications", "users"
  add_foreign_key "payments", "constructions"
  add_foreign_key "permitted_measure_units", "materials"
  add_foreign_key "permitted_measure_units", "measure_units"
  add_foreign_key "petty_cash_expenses", "petty_cashes"
  add_foreign_key "petty_cashes", "constructions"
  add_foreign_key "purchase_orders", "invoices"
  add_foreign_key "purchase_orders", "requisitions"
  add_foreign_key "requisitions", "constructions"
  add_foreign_key "requisitions", "users"
end
