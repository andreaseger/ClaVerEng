require 'spec_helper'
require 'models/job.rb'

describe Job do
  subject(:job) {Job.find(2343)}
  it {should respond_to(:original_function_id)}
  it {should respond_to(:original_career_level_id)}
  it {should respond_to(:original_industry_id)}
  it {should respond_to(:checked_correct?)}
end