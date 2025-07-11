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

ActiveRecord::Schema[8.0].define(version: 2025_07_10_215311) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answer_options", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.string "option_text", null: false
    t.boolean "is_correct", default: false, null: false
    t.text "explanation"
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answer_options_on_question_id"
  end

  create_table "content_topics", force: :cascade do |t|
    t.bigint "content_unit_id", null: false
    t.bigint "topic_id", null: false
    t.integer "relevance", default: 1
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_unit_id", "topic_id"], name: "index_content_topics_on_content_unit_id_and_topic_id", unique: true
    t.index ["content_unit_id"], name: "index_content_topics_on_content_unit_id"
    t.index ["topic_id"], name: "index_content_topics_on_topic_id"
  end

  create_table "content_units", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "parent_id", null: false
    t.string "title", null: false
    t.string "slug", null: false
    t.integer "state", default: 0, null: false
    t.text "description", null: false
    t.integer "position", null: false
    t.datetime "lock_expire_at", null: false
    t.bigint "created_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_content_units_on_slug", unique: true
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "content_unit_id", null: false
    t.datetime "enrolled_at", null: false
    t.integer "state", default: 0, null: false
    t.decimal "progress_percent", precision: 5, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_unit_id"], name: "index_enrollments_on_content_unit_id"
    t.index ["user_id", "content_unit_id"], name: "index_enrollments_on_user_id_and_content_unit_id", unique: true
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "evaluation_sections", force: :cascade do |t|
    t.bigint "evaluation_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.integer "time_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_id"], name: "index_evaluation_sections_on_evaluation_id"
  end

  create_table "evaluation_settings", force: :cascade do |t|
    t.bigint "evaluation_id", null: false
    t.integer "attempts_allowed", default: 1
    t.boolean "shuffle_questions", default: true, null: false
    t.boolean "show_results", default: false, null: false
    t.boolean "show_feedback", default: false, null: false
    t.jsonb "config"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_id"], name: "index_evaluation_settings_on_evaluation_id"
  end

  create_table "evaluations", force: :cascade do |t|
    t.string "type", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.integer "time_limit"
    t.integer "state", default: 0, null: false
    t.bigint "content_unit_id", null: false
    t.bigint "created_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_unit_id"], name: "index_evaluations_on_content_unit_id"
  end

  create_table "group_courses", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "content_unit_id", null: false
    t.datetime "assigned_at", null: false
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_unit_id"], name: "index_group_courses_on_content_unit_id"
    t.index ["group_id", "content_unit_id"], name: "index_group_courses_on_group_id_and_content_unit_id", unique: true
    t.index ["group_id"], name: "index_group_courses_on_group_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.datetime "joined_at"
    t.bigint "invited_by"
    t.string "invited_token"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "index_group_memberships_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "group_type", null: false
    t.bigint "mentor_id"
    t.bigint "academic_id"
    t.integer "state", default: 0
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_groups_on_slug", unique: true
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "profiles", force: :cascade do |t|
    t.text "bio"
    t.string "linkedin_url"
    t.string "github_url"
    t.string "website_url"
    t.string "location"
    t.string "company_name"
    t.string "job_title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "evaluation_id", null: false
    t.bigint "evaluation_section_id", null: false
    t.bigint "topic_id"
    t.text "statement", null: false
    t.integer "question_type", null: false
    t.integer "position", null: false
    t.text "explanation"
    t.integer "points", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_id"], name: "index_questions_on_evaluation_id"
    t.index ["evaluation_section_id"], name: "index_questions_on_evaluation_section_id"
    t.index ["topic_id"], name: "index_questions_on_topic_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "submission_answers", force: :cascade do |t|
    t.bigint "submission_id", null: false
    t.bigint "question_id", null: false
    t.bigint "answer_option_id", null: false
    t.text "text_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_correct"
    t.boolean "#<ActiveRecord::ConnectionAdapters::PostgreSQL::TableDefinition"
    t.index ["answer_option_id"], name: "index_submission_answers_on_answer_option_id"
    t.index ["question_id"], name: "index_submission_answers_on_question_id"
    t.index ["submission_id"], name: "index_submission_answers_on_submission_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "evaluation_id", null: false
    t.datetime "submitted_at"
    t.integer "score"
    t.integer "state"
    t.text "feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluation_id"], name: "index_submissions_on_evaluation_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.bigint "parent_id"
    t.integer "state", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_topics_on_name", unique: true
    t.index ["parent_id"], name: "index_topics_on_parent_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "state", default: "pending", null: false
    t.string "provider"
    t.string "uid"
    t.string "country"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "answer_options", "questions"
  add_foreign_key "content_topics", "content_units"
  add_foreign_key "content_topics", "topics"
  add_foreign_key "content_units", "content_units", column: "parent_id"
  add_foreign_key "enrollments", "content_units"
  add_foreign_key "enrollments", "users"
  add_foreign_key "evaluation_sections", "evaluations"
  add_foreign_key "evaluation_settings", "evaluations"
  add_foreign_key "evaluations", "content_units"
  add_foreign_key "evaluations", "users", column: "created_by"
  add_foreign_key "group_courses", "content_units"
  add_foreign_key "group_courses", "groups"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "group_memberships", "users", column: "invited_by"
  add_foreign_key "groups", "users", column: "academic_id"
  add_foreign_key "groups", "users", column: "mentor_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "questions", "evaluation_sections"
  add_foreign_key "questions", "evaluations"
  add_foreign_key "questions", "topics"
  add_foreign_key "submission_answers", "answer_options"
  add_foreign_key "submission_answers", "questions"
  add_foreign_key "submission_answers", "submissions"
  add_foreign_key "submissions", "evaluations"
  add_foreign_key "submissions", "users"
  add_foreign_key "topics", "topics", column: "parent_id"
end
