require "spec_helper"

shared_examples_for 'a selector' do
  let(:selector) { described_class.new }
  let(:data) { FactoryGirl.build(:data) }

  it "should create and array with 0 and 1's" do
    vector = selector.generate_vector(data, :function)
    vector.data.each do |e|
      [0,1].should include(e)
    end
  end
  it "should be able to process multiple data entries at once" do
    selector.generate_vectors([data], :function).each do |e|
      e.should eq(selector.generate_vector(data, :function))
    end
  end
end
