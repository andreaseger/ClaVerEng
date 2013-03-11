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
