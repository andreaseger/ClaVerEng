require "spec_helper"
require 'selectors/simple.rb'

describe Selector::Simple do
  let(:simple) { Selector::Simple.new }
  it "should have select_feature_vector implemented" do
    expect { simple.select_feature_vector([]) }.to_not raise_error
  end
end