require "spec_helper"
load 'selectors/base.rb'

describe Selector::Base do
  let(:base) { Selector::Base.new }
  it { base.should respond_to :process }
end