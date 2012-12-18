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

ActiveRecord::Schema.define(:version => 20121206153807) do

  create_table "career_levels", :force => true do |t|
    t.integer "sortno",         :limit => 2,   :null => false
    t.string  "label",          :limit => 64,  :null => false
    t.string  "comment",                       :null => false
    t.string  "urlified",       :limit => 256, :null => false
    t.string  "name",           :limit => 250, :null => false
    t.string  "urlified_en_gb", :limit => 256, :null => false
    t.string  "urlified_fr",    :limit => 256, :null => false
    t.string  "urlified_it",    :limit => 256, :null => false
    t.string  "urlified_en_us", :limit => 256, :null => false
    t.string  "urlified_es",    :limit => 256, :null => false
    t.string  "urlified_nl",    :limit => 256, :null => false
  end

  add_index "career_levels", ["urlified"], :name => "career_levels_urlified", :unique => true

  create_table "companies", :force => true do |t|
    t.string   "name",             :limit => 250,                     :null => false
    t.integer  "parent_id"
    t.integer  "owner_id",                                            :null => false
    t.integer  "company_class_id", :limit => 2,                       :null => false
    t.string   "url",              :limit => 250
    t.string   "career_url",       :limit => 500
    t.string   "description",      :limit => 1000
    t.string   "note",             :limit => 1000
    t.integer  "jobs_count",                                          :null => false
    t.datetime "last_checked",                                        :null => false
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
    t.integer  "main_industry_id"
    t.integer  "main_geocode_id",                                     :null => false
    t.boolean  "deleted",                                             :null => false
    t.string   "urlified",         :limit => 256
    t.boolean  "disabled",                                            :null => false
    t.integer  "lft"
    t.integer  "rgt"
    t.boolean  "has_logo",                         :default => false, :null => false
  end

  add_index "companies", ["lft"], :name => "index_companies_on_lft"
  add_index "companies", ["urlified"], :name => "companies_urlified", :unique => true

  create_table "companies_industries", :id => false, :force => true do |t|
    t.integer "company_id",               :null => false
    t.integer "industry_id", :limit => 2, :null => false
  end

  add_index "companies_industries", ["company_id", "industry_id"], :name => "index_companies_industries_on_company_id_and_industry_id", :unique => true
  add_index "companies_industries", ["company_id"], :name => "companies_industries_company"

  create_table "country_versions", :force => true do |t|
    t.string "name",  :limit => 16, :null => false
    t.string "label", :limit => 32, :null => false
  end

  create_table "education_fields", :force => true do |t|
    t.integer "sortno", :limit => 2
    t.string  "label",  :limit => 100, :null => false
  end

  create_table "education_fields_jobs", :id => false, :force => true do |t|
    t.integer "education_field_id", :limit => 2, :null => false
    t.integer "job_id",                          :null => false
  end

  add_index "education_fields_jobs", ["job_id"], :name => "education_fields_jobs_job_id"

  create_table "functions", :force => true do |t|
    t.integer "sortno",          :limit => 2,   :null => false
    t.string  "label",           :limit => 100, :null => false
    t.boolean "industry_affine"
    t.string  "urlified",        :limit => 256, :null => false
    t.string  "name",            :limit => 250, :null => false
    t.string  "urlified_en_gb",  :limit => 256, :null => false
    t.string  "urlified_fr",     :limit => 256, :null => false
    t.string  "urlified_it",     :limit => 256, :null => false
    t.string  "urlified_en_us",  :limit => 256, :null => false
    t.string  "urlified_es",     :limit => 256, :null => false
    t.string  "urlified_nl",     :limit => 256, :null => false
  end

  add_index "functions", ["urlified"], :name => "functions_urlified", :unique => true

  create_table "graduations", :force => true do |t|
    t.integer "sortno", :limit => 2,   :null => false
    t.string  "label",  :limit => 100, :null => false
  end

  create_table "graduations_jobs", :id => false, :force => true do |t|
    t.integer "graduation_id", :limit => 2, :null => false
    t.integer "job_id",                     :null => false
  end

  add_index "graduations_jobs", ["job_id"], :name => "graduations_jobs_job_id"

  create_table "industries", :force => true do |t|
    t.string  "label",          :limit => 256,  :null => false
    t.integer "level",          :limit => 2,    :null => false
    t.integer "parent_id",      :limit => 2
    t.integer "gparent_id",     :limit => 2
    t.integer "ggparent_id",    :limit => 2
    t.string  "synonyms",       :limit => 1000
    t.string  "urlified",       :limit => 256,  :null => false
    t.string  "name",           :limit => 250,  :null => false
    t.string  "label_en_gb",    :limit => 256,  :null => false
    t.string  "synonyms_en_gb", :limit => 1000
    t.string  "urlified_en_gb", :limit => 256,  :null => false
    t.string  "label_fr",       :limit => 256,  :null => false
    t.string  "synonyms_fr",    :limit => 1000
    t.string  "urlified_fr",    :limit => 256,  :null => false
    t.string  "label_it",       :limit => 256,  :null => false
    t.string  "synonyms_it",    :limit => 1000
    t.string  "urlified_it",    :limit => 256,  :null => false
    t.string  "label_en_us",    :limit => 256,  :null => false
    t.string  "synonyms_en_us", :limit => 1000
    t.string  "urlified_en_us", :limit => 256,  :null => false
    t.string  "label_es",       :limit => 256,  :null => false
    t.string  "synonyms_es",    :limit => 1000
    t.string  "urlified_es",    :limit => 256,  :null => false
    t.string  "label_nl",       :limit => 256,  :null => false
    t.string  "synonyms_nl",    :limit => 1000
    t.string  "urlified_nl",    :limit => 256,  :null => false
  end

  add_index "industries", ["parent_id"], :name => "industries_parent_id"
  add_index "industries", ["urlified"], :name => "idx_industries_urlified", :unique => true

  create_table "ja_qc_check_status", :force => true do |t|
    t.integer "qc_job_check_id"
    t.boolean "check_status"
  end

  create_table "ja_qc_job_checks", :force => true do |t|
    t.integer  "job_id"
    t.integer  "controller_id"
    t.integer  "approver_id"
    t.integer  "wrong_company_id"
    t.integer  "wrong_geocode_id"
    t.integer  "wrong_industry_id"
    t.boolean  "wrong_title"
    t.integer  "wrong_career_level_id"
    t.integer  "wrong_function_id"
    t.boolean  "wrong_salary"
    t.boolean  "wrong_expiry_date"
    t.boolean  "wrong_description"
    t.boolean  "wrong_url"
    t.boolean  "wrong_language"
    t.datetime "created_at"
  end

  add_index "ja_qc_job_checks", ["job_id"], :name => "index_ja_qc_job_checks_on_job_id", :unique => true

  create_table "job_languages", :force => true do |t|
    t.integer "job_id",                         :null => false
    t.integer "language_id",       :limit => 2, :null => false
    t.integer "language_skill_id", :limit => 2, :null => false
  end

  add_index "job_languages", ["job_id"], :name => "job_languages_job_id"

  create_table "job_salary_ranges", :force => true do |t|
    t.integer "sortno",             :limit => 2,   :null => false
    t.string  "label",              :limit => 100, :null => false
    t.integer "min_salary",                        :null => false
    t.integer "max_salary",                        :null => false
    t.string  "urlified",           :limit => 256, :null => false
    t.integer "country_version_id", :limit => 2,   :null => false
    t.integer "slider_position"
    t.string  "slider_label",       :limit => 16
    t.integer "slider_salary"
  end

  add_index "job_salary_ranges", ["urlified"], :name => "job_salary_ranges_urlified", :unique => true

  create_table "job_status", :force => true do |t|
    t.integer "sortno",         :limit => 2,   :null => false
    t.string  "name",           :limit => 250, :null => false
    t.string  "label",          :limit => 250, :null => false
    t.string  "external_label"
  end

  create_table "jobs", :force => true do |t|
    t.string   "title",                            :limit => 250,                     :null => false
    t.boolean  "confidential",                                                        :null => false
    t.string   "url",                              :limit => 1000
    t.string   "description",                      :limit => nil,                     :null => false
    t.string   "summary",                          :limit => 1000,                    :null => false
    t.integer  "company_id"
    t.integer  "language_id",                                                         :null => false
    t.integer  "career_level_id",                  :limit => 2,                       :null => false
    t.integer  "job_salary_range_id",              :limit => 2
    t.integer  "poster_id"
    t.integer  "owner_id"
    t.integer  "job_status_id",                    :limit => 2,    :default => 1,     :null => false
    t.datetime "published_at"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.boolean  "show_salary",                                                         :null => false
    t.string   "notes",                            :limit => 1000
    t.integer  "calculated_salary"
    t.boolean  "salary_changed"
    t.integer  "function_id",                                                         :null => false
    t.datetime "reindex"
    t.string   "internals",                        :limit => 1000
    t.integer  "geocode_id",                                                          :null => false
    t.integer  "industry_id",                                                         :null => false
    t.boolean  "deleted",                                                             :null => false
    t.string   "company_name",                     :limit => 250
    t.integer  "apply_counter",                    :limit => 2
    t.integer  "lock_version",                     :limit => 2,                       :null => false
    t.integer  "index_expired",                    :limit => 2
    t.string   "last_approved",                    :limit => 4096
    t.string   "contact_email",                    :limit => 250
    t.datetime "released_at"
    t.integer  "given_salary"
    t.integer  "queued_job_id"
    t.integer  "country_version_id",               :limit => 2,                       :null => false
    t.date     "expires_on"
    t.integer  "external_ref_id"
    t.integer  "to_blame_id"
    t.integer  "lock_admin_id"
    t.integer  "job_type_id"
    t.string   "reference",                        :limit => 30
    t.boolean  "published_active",                                 :default => false
    t.boolean  "published_catalog",                                :default => false
    t.integer  "publish_for_days"
    t.string   "salary_info",                      :limit => 250
    t.string   "expertise",                        :limit => 250
    t.string   "visible_location",                 :limit => 250
    t.text     "routing_email_addresses"
    t.integer  "employer_company_id"
    t.string   "source_title"
    t.integer  "job_premium_type_id",              :limit => 2,                       :null => false
    t.datetime "job_status_changed_at",                                               :null => false
    t.boolean  "send_job_alert_mail"
    t.boolean  "has_company_logo_old"
    t.integer  "job_application_strategy_id"
    t.string   "routing_redirect_url",             :limit => 1000
    t.boolean  "show_company_logo"
    t.string   "title_urlified",                   :limit => 300
    t.integer  "job_display_strategy_id"
    t.boolean  "show_recruiter"
    t.boolean  "publish_search_engines"
    t.boolean  "published_exports"
    t.boolean  "published_social_media"
    t.boolean  "published_adwords"
    t.boolean  "publish_adwords"
    t.boolean  "publish_partners"
    t.boolean  "publish_social_media"
    t.boolean  "published_search_engines"
    t.boolean  "publish_exports"
    t.integer  "job_page_id"
    t.datetime "last_job_alert_mail_sent_at"
    t.datetime "last_job_alert_mail_requested_at"
    t.integer  "job_logo_id"
    t.integer  "job_pdf_page_id"
    t.integer  "job_applications_count",                           :default => 0
    t.integer  "job_applications_new_count",                       :default => 0
    t.integer  "job_trial_id"
  end

  add_index "jobs", ["company_id"], :name => "jobs_company_id"
  add_index "jobs", ["country_version_id", "career_level_id"], :name => "jobs_country_version_career_level"
  add_index "jobs", ["country_version_id", "company_id"], :name => "jobs_country_version_company"
  add_index "jobs", ["country_version_id", "function_id"], :name => "jobs_country_version_function"
  add_index "jobs", ["country_version_id", "industry_id"], :name => "jobs_country_version_industry"
  add_index "jobs", ["country_version_id", "job_salary_range_id"], :name => "jobs_country_version_salary"
  add_index "jobs", ["expires_on"], :name => "jobs_expires_on"
  add_index "jobs", ["external_ref_id"], :name => "index_jobs_on_external_ref_id"
  add_index "jobs", ["geocode_id"], :name => "jobs_geocode"
  add_index "jobs", ["industry_id"], :name => "jobs_industry"
  add_index "jobs", ["job_logo_id"], :name => "index_jobs_on_job_logo_id"
  add_index "jobs", ["job_page_id"], :name => "index_jobs_on_job_page_id"
  add_index "jobs", ["job_status_id", "updated_at", "id"], :name => "jobs_job_status_id_update_at_id"
  add_index "jobs", ["job_trial_id"], :name => "index_jobs_on_job_trial_id"
  add_index "jobs", ["job_type_id"], :name => "index_jobs_on_job_type_id"
  add_index "jobs", ["lock_admin_id"], :name => "index_jobs_on_lock_admin_id"
  add_index "jobs", ["poster_id"], :name => "jobs_poster_id"
  add_index "jobs", ["publish_exports"], :name => "index_jobs_on_publish_exports"
  add_index "jobs", ["publish_search_engines"], :name => "index_jobs_on_publish_search_engines"
  add_index "jobs", ["published_active"], :name => "index_jobs_on_published_active"
  add_index "jobs", ["published_catalog"], :name => "index_jobs_on_published_catalog"
  add_index "jobs", ["queued_job_id"], :name => "jobs_queued_job_id"
  add_index "jobs", ["reference"], :name => "index_jobs_on_reference"
  add_index "jobs", ["to_blame_id"], :name => "index_jobs_on_to_blame_id"
  add_index "jobs", ["updated_at"], :name => "jobs_updated_at"

  create_table "languages", :force => true do |t|
    t.string  "label",           :limit => 40, :null => false
    t.string  "code",            :limit => 8,  :null => false
    t.boolean "system_language",               :null => false
    t.boolean "user_language",                 :null => false
  end

  create_table "predictors", :force => true do |t|
    t.string   "classification",                           :null => false
    t.text     "serialized_model",                         :null => false
    t.string   "used_preprocessor",                        :null => false
    t.string   "used_selector",                            :null => false
    t.text     "dictionary",                               :null => false
    t.text     "selector_properties"
    t.text     "preprocessor_properties"
    t.string   "used_trainer"
    t.integer  "samplesize"
    t.integer  "dictionary_size"
    t.float    "overall_accuracy",        :default => 0.0
    t.float    "geometric_mean",          :default => 0.0
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
  end

  add_index "predictors", ["classification"], :name => "index_predictors_on_classification"

end