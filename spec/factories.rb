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
  factory :job_gender_in_title, parent: :dummy_job do
    title "Some Job title (m|w)"
  end
  factory :job_gender_in_title_alt, parent: :dummy_job do
    title "Some Job title (m/w)"
  end
end