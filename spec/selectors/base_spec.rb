require "spec_helper"
require 'selectors/base.rb'

describe Selector::Base do
  let(:base) { Selector::Base.new }
  it { base.should respond_to :select_feature_vector }
end