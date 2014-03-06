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

ActiveRecord::Schema.define(version: 20140306202654) do

  create_table "instances", force: true do |t|
    t.string   "instance_id"
    t.string   "name"
    t.string   "description"
    t.string   "chef_env"
    t.string   "service"
    t.string   "subservice"
    t.text     "contents"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",       default: 0, null: false
    t.string   "state"
    t.string   "instance_type"
    t.datetime "launch_time"
    t.string   "availability_zone"
    t.string   "subnet_id"
    t.string   "private_ip_address"
  end

  add_index "instances", ["chef_env", "name"], name: "index_instances_on_chef_env_and_name"
  add_index "instances", ["chef_env", "service"], name: "index_instances_on_chef_env_and_service"
  add_index "instances", ["instance_id"], name: "index_instances_on_instance_id", unique: true

end
