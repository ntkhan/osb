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

ActiveRecord::Schema.define(:version => 20121221153111) do

  create_table "client_billing_infos", :force => true do |t|
    t.string   "country"
    t.string   "street_address_1"
    t.string   "street_address_2"
    t.string   "city"
    t.string   "province_or_state"
    t.string   "postal_or_zip_code"
    t.string   "phone_business"
    t.string   "phone_mobile"
    t.string   "phone_home"
    t.string   "fax"
    t.string   "notes"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "organization"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "user_name"
    t.string   "password"
    t.string   "sec_adrs_country"
    t.string   "sec_adrs_street_address_1"
    t.string   "sec_adrs_street_address_2"
    t.string   "sec_adrs_city"
    t.string   "sec_adrs_province_or_state"
    t.string   "sec_adrs_post_or_zip_code"
    t.string   "status"
    t.datetime "last_login"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

end
