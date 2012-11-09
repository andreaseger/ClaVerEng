require 'spec_helper'
require "preprocessors/base.rb"

describe Preprocessor::Base do
  let(:base) { Preprocessor::Base.new }
  it { base.should respond_to :process }
end