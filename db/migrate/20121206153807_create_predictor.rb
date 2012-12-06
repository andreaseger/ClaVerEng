class CreatePredictor < ActiveRecord::Migration
  def up
    create_table :predictor do |t|
      # serialized svm model
      t.text :serialized_model, null: false

      # preprocessor/selector
      t.string :used_preprocessor, null: false
      t.string :used_selector, null: false
      t.text :dictionary, null: false

      # evaluation (in percent)
      t.float :overall_accuracy, default: 0
      t.float :geometric_mean, default: 0
      t.float :class_precision, default: 0
      t.float :class_recall, default: 0

      # which classification
      t.boolean :function, default: false
      t.boolean :industry, default: false
      t.boolean :career_level, default: false

      # TODO save some image blob here
      # with graphs/distribution of the svm from training
      # would also need a nice show method implementation in jruby land

      # TODO evtl also some statistics from productive usage

      t.timestamps
    end
  end

  def down
    drop_table :predictor
  end
end
