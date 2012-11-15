# encoding: UTF-8
require 'factory_girl'
require 'ostruct'

FactoryGirl.define do
  factory :dummy_job, class: OpenStruct do
    title "Meh"
    description "Foo Bar"
    summary "Really lot of work to do"
  end




  factory :data, class: OpenStruct do
    data ["haus fooo garten baaz pferd fooo"]
    career_level_id 7
    checked_correct true
  end
  factory :data_w_short_words, parent: :data do
    data ["auto foo pferd bz gooo fooo 2"]
  end
  factory :data_w_multiple_sections, parent: :data do
    data ["meeh foo auto","bz baaz fooo 2"]
  end
end
