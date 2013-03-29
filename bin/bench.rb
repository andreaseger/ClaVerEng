#!/usr/bin/env ruby

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'config/setup'
require 'lib/runner/base'
require 'benchmark'

class PreprocessingBench < Runner::Base
  def self.bench count
    new.bench count
  end
  def bench count
    @classification = :function
    @preprocessor = create_preprocessor(:simple, parallel: false)
    @preprocessor2 = create_preprocessor(:simple, parallel: true)
    @selector = create_selector(:simple, parallel: false)
    @selector2 = create_selector(:simple, parallel: true)
    parameter_set = ParameterSet.real(0.009687053222661581, 65.71704225453483)
    puts "count: #{count}"
    Benchmark.bm(25) do |x|
      x.report('fetching jobs:') { @jobs = fetch_jobs(count,0) }
      x.report('preprocessing:') { @data = @preprocessor.process(@jobs) }
      x.report('preprocessing(p):') { @preprocessor2.process(@jobs) }
      x.report('generate:') { @set = @selector.generate_vectors(@data) }
      x.report('generate(p):') { @selector2.generate_vectors(@data) }
      x.report("make problem:") { @problem = Libsvm::Problem.new.tap{|p|
                                    p.set_examples(@set.map(&:label),
                                                   @set.map{|e| Libsvm::Node.features(e.data)}
                                    )} }
      x.report('train:'){ @model = ByParameter.new.train(@set, parameter_set) }
      x.report("evaluate:") { @evaluator = SvmTrainer::Evaluator::AllInOne.new(@model)
                              @evaluator.evaluate_dataset(@problem) }
    end
  end
end

PreprocessingBench.bench ARGV.first.to_i