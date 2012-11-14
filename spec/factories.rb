# encoding: UTF-8
require 'factory_girl'
require 'ostruct'

class DummyJob < OpenStruct
end

FactoryGirl.define do
  factory :dummy_job do
    title "Meh"
    description "Foo Bar"
    summary "Really lot of work to do"
  end
  factory :data, class: OpenStruct do
    data ["haus fooo garten baaz pferd fooo"]
    checked_correct true
  end
  factory :data_w_short_words, parent: :data do
    data ["auto foo pferd bz gooo fooo 2"]
    checked_correct true
  end
  factory :data_w_multiple_sections, parent: :data do
    data ["meeh foo auto","bz baaz fooo 2"]
    checked_correct true
  end
end
