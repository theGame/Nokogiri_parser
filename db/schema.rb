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

ActiveRecord::Schema.define(version: 20131117131757) do

  create_table "contents", force: true do |t|
    t.string   "url"
    t.string   "filter1"
    t.string   "filter2"
    t.string   "filter3"
    t.integer  "timeout"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
    t.string   "encoding"
    t.string   "metainfo"
    t.string   "reg_exp_filter_1"
  end

end
