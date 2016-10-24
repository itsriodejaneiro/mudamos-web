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

ActiveRecord::Schema.define(version: 20160202181513) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_stat_statements"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "admin_users", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.datetime "deleted_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "admin_type",             default: 0
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "alias_names", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "alias_names", ["name"], name: "index_alias_names_on_name", using: :btree

  create_table "blog_posts", force: :cascade do |t|
    t.integer  "plugin_relation_id"
    t.string   "title"
    t.text     "content"
    t.string   "picture"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "is_readonly"
    t.datetime "release_date"
    t.string   "slug"
    t.datetime "deleted_at"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "author_name"
    t.boolean  "active",               default: true
    t.boolean  "highlighted",          default: false
  end

  add_index "blog_posts", ["plugin_relation_id"], name: "index_blog_posts_on_plugin_relation_id", using: :btree

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "uf",         limit: 2
    t.integer  "status",               default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "subject_id"
    t.integer  "user_id"
    t.text     "content"
    t.boolean  "was_intermediated",      default: false
    t.boolean  "should_show_alias"
    t.integer  "parent_id"
    t.integer  "lft",                                    null: false
    t.integer  "rgt",                                    null: false
    t.integer  "depth",                  default: 0,     null: false
    t.integer  "children_count",         default: 0,     null: false
    t.integer  "likes_count",            default: 0,     null: false
    t.integer  "dislikes_count",         default: 0,     null: false
    t.integer  "reports_count",          default: 0,     null: false
    t.integer  "comment_versions_count", default: 0,     null: false
    t.string   "slug"
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "is_anonymous"
  end

  add_index "comments", ["deleted_at"], name: "index_comments_on_deleted_at", using: :btree
  add_index "comments", ["lft"], name: "index_comments_on_lft", using: :btree
  add_index "comments", ["parent_id"], name: "index_comments_on_parent_id", using: :btree
  add_index "comments", ["rgt"], name: "index_comments_on_rgt", using: :btree
  add_index "comments", ["subject_id"], name: "index_comments_on_subject_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "compilation_files", force: :cascade do |t|
    t.integer  "plugin_relation_id"
    t.string   "title1",             default: "Perfil de Cadastrados na Plataforma"
    t.string   "title2",             default: "Adesão dos Participantes aos Assuntos"
    t.string   "title3",             default: "Participação de Anônimos X Identificados"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
  end

  add_index "compilation_files", ["deleted_at"], name: "index_compilation_files_on_deleted_at", using: :btree
  add_index "compilation_files", ["plugin_relation_id"], name: "index_compilation_files_on_plugin_relation_id", using: :btree

  create_table "credit_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "position"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "credit_categories", ["deleted_at"], name: "index_credit_categories_on_deleted_at", using: :btree

  create_table "credits", force: :cascade do |t|
    t.integer  "credit_category_id"
    t.string   "name"
    t.text     "content"
    t.string   "url"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "credits", ["credit_category_id"], name: "index_credits_on_credit_category_id", using: :btree
  add_index "credits", ["deleted_at"], name: "index_credits_on_deleted_at", using: :btree

  create_table "cycles", force: :cascade do |t|
    t.string   "name"
    t.string   "subdomain"
    t.string   "title"
    t.string   "about"
    t.datetime "initial_date"
    t.datetime "final_date"
    t.string   "slug"
    t.datetime "deleted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "color"
    t.string   "description"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "dislikes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "dislikes", ["comment_id"], name: "index_dislikes_on_comment_id", using: :btree
  add_index "dislikes", ["user_id"], name: "index_dislikes_on_user_id", using: :btree

  create_table "email_notifications", force: :cascade do |t|
    t.integer  "notification_id"
    t.string   "to_email"
    t.string   "from_email"
    t.text     "subject"
    t.text     "content"
    t.datetime "sent_at"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "grid_highlights", force: :cascade do |t|
    t.integer  "target_object_id"
    t.string   "target_object_type"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.boolean  "blog",               default: false
    t.boolean  "vocabulary",         default: false
  end

  add_index "grid_highlights", ["target_object_id"], name: "index_grid_highlights_on_target_object_id", using: :btree

  create_table "internal_notifications", force: :cascade do |t|
    t.integer  "notification_id"
    t.datetime "read_at"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "likes", ["comment_id"], name: "index_likes_on_comment_id", using: :btree
  add_index "likes", ["user_id"], name: "index_likes_on_user_id", using: :btree

  create_table "materials", force: :cascade do |t|
    t.string   "author"
    t.string   "title"
    t.string   "source"
    t.datetime "publishing_date"
    t.string   "category"
    t.string   "external_link"
    t.string   "themes"
    t.string   "keywords"
    t.string   "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "cycle_id"
    t.integer  "position"
    t.integer  "plugin_relation_id"
  end

  add_index "materials", ["cycle_id"], name: "index_materials_on_cycle_id", using: :btree
  add_index "materials", ["plugin_relation_id"], name: "index_materials_on_plugin_relation_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "target_user_id"
    t.string   "target_user_type"
    t.integer  "target_object_id"
    t.string   "target_object_type"
    t.text     "title"
    t.text     "description"
    t.string   "view_url"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "picture_url"
  end

  create_table "omniauth_identities", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "permissions", force: :cascade do |t|
    t.integer  "target_id"
    t.string   "target_type"
    t.boolean  "can_manage_users"
    t.boolean  "can_view"
    t.boolean  "can_create"
    t.boolean  "can_update"
    t.boolean  "can_delete"
    t.datetime "deleted_at"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "permissions", ["deleted_at"], name: "index_permissions_on_deleted_at", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "pg_search_documents", ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id", using: :btree

  create_table "phases", force: :cascade do |t|
    t.integer  "cycle_id"
    t.string   "name"
    t.string   "description"
    t.string   "tooltip"
    t.datetime "initial_date"
    t.datetime "final_date"
    t.string   "slug"
    t.datetime "deleted_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  add_index "phases", ["deleted_at"], name: "index_phases_on_deleted_at", using: :btree

  create_table "plugin_relations", force: :cascade do |t|
    t.integer  "related_id"
    t.string   "related_type"
    t.integer  "plugin_id"
    t.boolean  "is_readonly"
    t.datetime "read_only_at"
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "slug"
  end

  add_index "plugin_relations", ["deleted_at"], name: "index_plugin_relations_on_deleted_at", using: :btree
  add_index "plugin_relations", ["related_type", "related_id"], name: "index_plugin_relations_on_related_type_and_related_id", using: :btree

  create_table "plugins", force: :cascade do |t|
    t.string   "name"
    t.string   "plugin_type"
    t.boolean  "can_be_readonly"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "icon_class"
  end

  add_index "plugins", ["deleted_at"], name: "index_plugins_on_deleted_at", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.string   "name"
    t.string   "short_name"
    t.string   "description"
    t.datetime "deleted_at"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "parent_id"
    t.integer  "lft",                              null: false
    t.integer  "rgt",                              null: false
    t.integer  "depth",                default: 0, null: false
    t.integer  "children_count",       default: 0, null: false
  end

  add_index "profiles", ["deleted_at"], name: "index_profiles_on_deleted_at", using: :btree

  create_table "push_notifications", force: :cascade do |t|
    t.integer  "notification_id"
    t.datetime "sent_at"
    t.datetime "deleted_at"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "reports", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "comment_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reports", ["comment_id"], name: "index_reports_on_comment_id", using: :btree
  add_index "reports", ["user_id"], name: "index_reports_on_user_id", using: :btree

  create_table "session_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "expire_at"
    t.string   "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "session_tokens", ["expire_at"], name: "index_session_tokens_on_expire_at", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "deleted_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
  end

  create_table "social_links", force: :cascade do |t|
    t.string   "provider"
    t.string   "link"
    t.string   "icon_class"
    t.text     "description"
    t.integer  "cycle_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "name"
  end

  add_index "social_links", ["cycle_id"], name: "index_social_links_on_cycle_id", using: :btree

  create_table "static_pages", force: :cascade do |t|
    t.string   "name"
    t.string   "title"
    t.string   "slug"
    t.integer  "cycle_id"
    t.text     "content"
    t.boolean  "show_on_footer", default: true
    t.boolean  "show_on_header", default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "static_pages", ["cycle_id"], name: "index_static_pages_on_cycle_id", using: :btree
  add_index "static_pages", ["deleted_at"], name: "index_static_pages_on_deleted_at", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.integer  "plugin_relation_id"
    t.string   "enunciation"
    t.string   "slug"
    t.datetime "deleted_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "question"
    t.string   "title"
    t.integer  "vocabulary_id"
    t.text     "tag_description"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "subjects", ["deleted_at"], name: "index_subjects_on_deleted_at", using: :btree
  add_index "subjects", ["plugin_relation_id"], name: "index_subjects_on_plugin_relation_id", using: :btree
  add_index "subjects", ["vocabulary_id"], name: "index_subjects_on_vocabulary_id", using: :btree

  create_table "subjects_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "subject_id"
    t.boolean  "agree",        default: false
    t.datetime "deleted_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "is_anonymous"
  end

  add_index "subjects_users", ["deleted_at"], name: "index_subjects_users_on_deleted_at", using: :btree
  add_index "subjects_users", ["subject_id"], name: "index_subjects_users_on_subject_id", using: :btree
  add_index "subjects_users", ["user_id"], name: "index_subjects_users_on_user_id", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "deleted_at"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "profile_id"
    t.date     "birthday"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.boolean  "alias_as_default",       default: false
    t.integer  "sub_profile_id"
    t.integer  "gender"
    t.string   "encrypted_name"
    t.string   "encrypted_cpf"
    t.string   "encrypted_birthday"
    t.string   "encrypted_state"
    t.string   "encrypted_city"
    t.string   "encrypted_alias_name"
    t.string   "encrypted_email"
    t.boolean  "is_admin",               default: false
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vocabularies", force: :cascade do |t|
    t.integer  "cycle_id"
    t.string   "title"
    t.string   "first_letter"
    t.text     "description"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "plugin_relation_id"
  end

  add_index "vocabularies", ["cycle_id"], name: "index_vocabularies_on_cycle_id", using: :btree
  add_index "vocabularies", ["plugin_relation_id"], name: "index_vocabularies_on_plugin_relation_id", using: :btree

  add_foreign_key "blog_posts", "plugin_relations"
  add_foreign_key "comments", "subjects"
  add_foreign_key "comments", "users"
  add_foreign_key "compilation_files", "plugin_relations"
  add_foreign_key "credits", "credit_categories"
  add_foreign_key "dislikes", "comments"
  add_foreign_key "dislikes", "users"
  add_foreign_key "likes", "comments"
  add_foreign_key "likes", "users"
  add_foreign_key "materials", "cycles"
  add_foreign_key "materials", "plugin_relations"
  add_foreign_key "reports", "comments"
  add_foreign_key "reports", "users"
  add_foreign_key "social_links", "cycles"
  add_foreign_key "static_pages", "cycles"
  add_foreign_key "subjects", "plugin_relations"
  add_foreign_key "subjects", "vocabularies"
  add_foreign_key "subjects_users", "subjects"
  add_foreign_key "subjects_users", "users"
  add_foreign_key "vocabularies", "cycles"
  add_foreign_key "vocabularies", "plugin_relations"
end
