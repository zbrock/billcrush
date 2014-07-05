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

ActiveRecord::Schema.define(:version => 20101223224604) do

  create_table "credits", :force => true do |t|
    t.integer  "member_id"
    t.integer  "amount_cents"
    t.integer  "transaction_id"
    t.boolean  "active",         :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "debits", :force => true do |t|
    t.integer  "amount_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "transaction_id"
    t.boolean  "active",         :default => false
    t.integer  "member_id"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "canonicalized_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", :force => true do |t|
    t.integer  "group_id"
    t.string   "name"
    t.boolean  "active",     :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "group_id"
    t.integer  "amount"
    t.boolean  "active",      :default => false
    t.datetime "deleted_at"
    t.boolean  "settlement",  :default => false
    t.datetime "date"
  end

end
