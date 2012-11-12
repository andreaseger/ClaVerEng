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
end