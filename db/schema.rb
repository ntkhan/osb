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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121228150402) do

  create_table "categories", :force => true do |t|
    t.string   "category"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "client_contacts", :force => true do |t|
    t.integer  "client_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone1"
    t.string   "phone2"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "organization_name"
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "home_phone"
    t.string   "mobile_number"
    t.string   "send_invoice_by"
    t.string   "country"
    t.string   "address_street1"
    t.string   "address_street2"
    t.string   "city"
    t.string   "province_state"
    t.string   "postal_zip_code"
    t.string   "industry"
    t.string   "company_size"
    t.string   "business_phone"
    t.string   "fax"
    t.text     "internal_notes"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "company_profiles", :force => true do |t|
    t.string   "org_name"
    t.string   "country"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "province_or_state"
    t.string   "postal_or_zip_code"
    t.string   "profession"
    t.string   "phone_business"
    t.string   "phone_mobile"
    t.string   "fax"
    t.string   "email"
    t.string   "time_zone"
    t.boolean  "auto_dst_adjustment"
    t.string   "currency_code"
    t.string   "currecy_symbol"
    t.string   "admin_first_name"
    t.string   "admin_last_name"
    t.string   "admin_email"
    t.decimal  "admin_billing_rate_per_hour", :precision => 10, :scale => 0
    t.string   "admin_user_name"
    t.string   "admin_password"
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  create_table "invoice_line_items", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "item_id"
    t.string   "item_name"
    t.string   "item_description"
    t.decimal  "item_unit_cost",   :precision => 10, :scale => 0
    t.decimal  "item_quantity",    :precision => 10, :scale => 0
    t.integer  "tax_1"
    t.integer  "tax_2"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "invoices", :force => true do |t|
    t.string   "invoice_number"
    t.datetime "invoice_date"
    t.string   "po_number"
    t.decimal  "discount_percentage", :precision => 10, :scale => 0
    t.integer  "client_id"
    t.text     "tems"
    t.text     "notes"
    t.string   "status"
    t.decimal  "sub_total",           :precision => 10, :scale => 0
    t.decimal  "discount_amount",     :precision => 10, :scale => 0
    t.decimal  "tax_amount",          :precision => 10, :scale => 0
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "item_name"
    t.string   "item_description"
    t.decimal  "unit_cost",        :precision => 10, :scale => 0
    t.integer  "quantity"
    t.integer  "tax_1"
    t.integer  "tax_2"
    t.boolean  "track_invetory"
    t.integer  "inventory"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "recurring_profile_line_items", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "item_id"
    t.string   "item_name"
    t.string   "item_description"
    t.decimal  "item_unit_cost",   :precision => 10, :scale => 0
    t.decimal  "item_quantity",    :precision => 10, :scale => 0
    t.integer  "tax_1"
    t.integer  "tax_2"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
  end

  create_table "recurring_profiles", :force => true do |t|
    t.datetime "first_invoice_date"
    t.string   "po_number"
    t.decimal  "discount_percentage", :precision => 10, :scale => 0
    t.string   "frequency"
    t.integer  "occurrences"
    t.boolean  "prorate"
    t.decimal  "prorate_for",         :precision => 10, :scale => 0
    t.integer  "gateway_id"
    t.integer  "client_id"
    t.text     "tems"
    t.text     "notes"
    t.string   "status"
    t.decimal  "sub_total",           :precision => 10, :scale => 0
    t.decimal  "discount_amount",     :precision => 10, :scale => 0
    t.decimal  "tax_amount",          :precision => 10, :scale => 0
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "password_salt"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
