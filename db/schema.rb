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

ActiveRecord::Schema[8.0].define(version: 2025_03_06_030918) do
  create_table "answers", force: :cascade do |t|
    t.integer "question_id"
    t.string "category"
    t.string "question_description"
    t.text "answer_choices"
    t.string "answer"
    t.boolean "correctness"
    t.string "student_email"
    t.string "date_completed"
    t.string "time_spent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", force: :cascade do |t|
    t.string "category"
    t.string "question"
    t.text "answer_choices"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.integer "uin"
    t.string "teacher"
    t.integer "teacher_id"
    t.boolean "authenticate", default: false
    t.index ["email"], name: "index_students_on_email", unique: true
  end

  create_table "teachers", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_teachers_on_email", unique: true
  end
end
