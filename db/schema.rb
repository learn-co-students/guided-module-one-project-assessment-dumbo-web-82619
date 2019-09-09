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

ActiveRecord::Schema.define(version: 2019_09_08_023103) do

  create_table "contractors", force: :cascade do |t|
    t.string "name"
    t.string "company_name"
    t.string "feilds"
    t.string "bio"
  end

  create_table "contracts", force: :cascade do |t|
    t.integer "contractor_id"
    t.integer "freelancer_id"
    t.string "description"
    t.integer "pay_out"
    t.string "start_date"
  end

  create_table "freelancers", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.integer "dob"
    t.string "certifications"
  end

end
