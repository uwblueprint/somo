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

ActiveRecord::Schema.define(version: 20161214003635) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "question_orders", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "next_question_id"
    t.integer  "response_choice_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "type",               null: false
  end

  add_index "question_orders", ["next_question_id"], name: "index_question_orders_on_next_question_id", using: :btree
  add_index "question_orders", ["question_id"], name: "index_question_orders_on_question_id", using: :btree
  add_index "question_orders", ["response_choice_id"], name: "index_question_orders_on_response_choice_id", using: :btree

  create_table "questions", force: :cascade do |t|
    t.text     "text"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "question_type"
    t.integer  "number"
    t.integer  "survey_id"
  end

  add_index "questions", ["number"], name: "index_questions_on_number", using: :btree
  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id", using: :btree

  create_table "respondents", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "respondents", ["phone_number"], name: "index_respondents_on_phone_number", unique: true, using: :btree

  create_table "response_choices", force: :cascade do |t|
    t.string   "key"
    t.text     "text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "question_id"
  end

  add_index "response_choices", ["question_id"], name: "index_response_choices_on_question_id", using: :btree

  create_table "responses", force: :cascade do |t|
    t.integer  "survey_response_id"
    t.integer  "question_id"
    t.integer  "respondent_id"
    t.text     "answer"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "responses", ["question_id"], name: "index_responses_on_question_id", using: :btree
  add_index "responses", ["respondent_id"], name: "index_responses_on_respondent_id", using: :btree
  add_index "responses", ["survey_response_id"], name: "index_responses_on_survey_response_id", using: :btree

  create_table "survey_execution_states", force: :cascade do |t|
    t.integer  "respondent_id"
    t.integer  "question_id"
    t.integer  "survey_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "status",        default: 0
  end

  add_index "survey_execution_states", ["question_id"], name: "index_survey_execution_states_on_question_id", using: :btree
  add_index "survey_execution_states", ["respondent_id"], name: "index_survey_execution_states_on_respondent_id", using: :btree
  add_index "survey_execution_states", ["survey_id"], name: "index_survey_execution_states_on_survey_id", using: :btree

  create_table "survey_responses", force: :cascade do |t|
    t.integer  "survey_id"
    t.integer  "respondent_id"
    t.datetime "completed_at"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "survey_responses", ["respondent_id"], name: "index_survey_responses_on_respondent_id", using: :btree
  add_index "survey_responses", ["survey_id"], name: "index_survey_responses_on_survey_id", using: :btree

  create_table "surveys", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "first_question_id"
    t.json     "parameters"
  end

  add_foreign_key "question_orders", "questions"
  add_foreign_key "question_orders", "questions", column: "next_question_id"
  add_foreign_key "question_orders", "response_choices"
  add_foreign_key "questions", "surveys"
  add_foreign_key "response_choices", "questions"
  add_foreign_key "responses", "questions"
  add_foreign_key "responses", "respondents"
  add_foreign_key "responses", "survey_responses"
  add_foreign_key "survey_execution_states", "questions"
  add_foreign_key "survey_execution_states", "respondents"
  add_foreign_key "survey_execution_states", "surveys"
  add_foreign_key "survey_responses", "respondents"
  add_foreign_key "survey_responses", "surveys"
end
