class CreatePredictor < ActiveRecord::Migration
  def up
    create_table :predictors do |t|
      # serialized svm model
      t.string :classification, null: false
      t.text :serialized_model, null: false

      # preprocessor, selector
      t.string :used_preprocessor, null: false
      t.string :used_selector, null: false

      # dictionary, parameter
      t.text :dictionary, null: false
      t.text :selector_properties
      t.text :preprocessor_properties

      # more info about the training
      t.string :used_trainer
      t.integer :samplesize
      t.integer :dictionary_size

      # evaluation (in percent) - float precision is enough
      t.float :overall_accuracy, default: 0
      t.float :geometric_mean, default: 0
      # t.float :class_precision, default: 0
      # t.float :class_recall, default: 0

      t.timestamps
    end
    #execute "ALTER TABLE predictors ADD CONSTRAINT CK_Classification CHECK (classification IN ('function', 'industry', 'career_level'))"
    add_index :predictors, :classification
  end

  def down
    drop_table :predictor
  end
end
