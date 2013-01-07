require "spec_helper"
require 'trainer/nelder_mead'

describe Trainer::NelderMead do
  let(:trainer) { NelderMead.new }
  before(:each) do
    trainer.stub(:func).returns(1)
  end
  context "#reflect" do
    let(:center) { ParameterSet.new(5,5) }
    it "should calculate the reflected point for (3,3) on (5,5)" do
      worst = ParameterSet.new(3,3)
      r=trainer.reflect(center, worst).key
      r.should == [7,7]
    end
    it "should calculate the reflected point for (7,3) on (5,5)" do
      worst = ParameterSet.new(7,3)
      r=trainer.reflect(center, worst).key
      r.should == [3,7]
    end
  end
  context "#contract" do
    context "#outside" do
      it "should just call reflect" do
        trainer.expects(:reflect).with(111,222,0.5)
        trainer.contract_outside(111,222)
      end
    end
    context "#inside" do
      let(:center) { ParameterSet.new(5,5) }
      it "should calculate the reflected point for (3,3) on (5,5)" do
        worst = ParameterSet.new(3,3)
        r=trainer.contract_inside(center, worst).key
        r.should == [4,4]
      end
      it "should calculate the reflected point for (7,3) on (5,5)" do
        worst = ParameterSet.new(7,3)
        r=trainer.contract_inside(center, worst).key
        r.should == [6,4]
      end
    end
  end
end