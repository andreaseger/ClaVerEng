require "spec_helper"
require 'selectors/base'

describe Selector::Base do
  let(:base) { Selector::Base.new }
  it { base.should respond_to :process }
end