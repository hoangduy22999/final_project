# frozen_string_literal: true

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
  enable_extension 'plpgsql'

  create_table 'cities', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'slug', null: false
    t.string 'name_with_type', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'index_cities_on_name'
  end

  create_table 'departments', force: :cascade do |t|
    t.string 'name', null: false
    t.integer 'manager_id'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['manager_id'], name: 'index_departments_on_manager_id'
    t.index ['name'], name: 'index_departments_on_name'
  end

  create_table 'districts', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'slug', null: false
    t.string 'name_with_type', null: false
    t.string 'path', null: false
    t.string 'path_with_type', null: false
    t.integer 'city_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['name'], name: 'index_districts_on_name'
  end

  create_table 'user_departments', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'department_id', null: false
    t.integer 'role', default: 0, null: false
    t.datetime 'start_date', null: false
    t.datetime 'end_date'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['department_id'], name: 'index_user_departments_on_department_id'
    t.index ['user_id'], name: 'index_user_departments_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name'
    t.string 'last_name'
    t.string 'email', default: '', null: false
    t.datetime 'birthday', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.integer 'role', default: 0, null: false
    t.integer 'gender', default: 0, null: false
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.integer 'sign_in_count', default: 0
    t.datetime 'current_sign_in_at', precision: 6
    t.datetime 'last_sign_in_at', precision: 6
    t.string 'current_sign_in_ip', limit: 255
    t.string 'last_sign_in_ip', limit: 255
    t.integer 'status', default: 0, null: false
    t.bigint 'district_id'
    t.string 'address', null: false
    t.string 'phone', null: false
    t.string 'avatar'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['district_id'], name: 'index_users_on_district_id'
    t.index ['email'], name: 'index_users_on_email'
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['role'], name: 'index_users_on_role'
    t.index ['status'], name: 'index_users_on_status'
  end

  add_foreign_key 'departments', 'users', column: 'manager_id', name: 'user'
  add_foreign_key 'districts', 'cities', name: 'city'
  add_foreign_key 'user_departments', 'departments', name: 'department'
  add_foreign_key 'user_departments', 'users', name: 'user'
  add_foreign_key 'users', 'districts', name: 'district'
end
