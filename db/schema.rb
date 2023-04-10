# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "name_with_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_cities_on_name"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.integer "manager_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["manager_id"], name: "index_departments_on_manager_id"
    t.index ["name"], name: "index_departments_on_name"
  end

  create_table "dependents", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.integer "relationship"
    t.date "birthday"
    t.string "phone"
    t.string "address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "name_with_type", null: false
    t.string "path", null: false
    t.string "path_with_type", null: false
    t.integer "city_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_districts_on_name"
  end

  create_table "educations", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "degree"
    t.string "specialization"
    t.date "end_date"
    t.date "start_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "holidays", force: :cascade do |t|
    t.string "name"
    t.date "start_date"
    t.date "end_date"
    t.text "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "leave_requests", force: :cascade do |t|
    t.integer "created_by"
    t.integer "leave_type"
    t.bigint "approve_by"
    t.integer "status"
    t.datetime "start_date"
    t.datetime "end_date"
    t.text "reason"
    t.integer "on_time"
    t.bigint "reference_ids", array: true
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "content", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "time_sheets", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "keeping_time"
    t.integer "keeping_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "change_by", default: 0
  end

  create_table "user_departments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "department_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["department_id"], name: "index_user_departments_on_department_id"
    t.index ["user_id"], name: "index_user_departments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", default: "", null: false
    t.datetime "birthday", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.integer "role", default: 0, null: false
    t.integer "gender", default: 0, null: false
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: 6
    t.datetime "last_sign_in_at", precision: 6
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.integer "status", default: 0, null: false
    t.bigint "district_id"
    t.bigint "city_id"
    t.string "address", null: false
    t.string "phone", null: false
    t.string "avatar"
    t.integer "salary"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["district_id"], name: "index_users_on_district_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role"], name: "index_users_on_role"
    t.index ["status"], name: "index_users_on_status"
  end

  create_table "work_experiences", force: :cascade do |t|
    t.bigint "user_id"
    t.string "company_name"
    t.string "job_title"
    t.date "from_date"
    t.date "end_date"
    t.string "job_description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "answers", "questions", name: "question"
  add_foreign_key "answers", "users", name: "user"
  add_foreign_key "departments", "users", column: "manager_id", name: "user"
  add_foreign_key "dependents", "users", name: "user"
  add_foreign_key "districts", "cities", name: "city"
  add_foreign_key "educations", "users", name: "user"
  add_foreign_key "leave_requests", "users", column: "approve_by", name: "approve_by"
  add_foreign_key "leave_requests", "users", name: "user"
  add_foreign_key "questions", "users", name: "user"
  add_foreign_key "time_sheets", "users", name: "user"
  add_foreign_key "user_departments", "departments", name: "department"
  add_foreign_key "user_departments", "users", name: "user"
  add_foreign_key "users", "districts", name: "district"
  add_foreign_key "work_experiences", "users", name: "user"
end
