#!/usr/bin/env ruby

require './config/setup'
require './lib/runner/single'
require 'benchmark'

class PreprocessingBench < Runner::Single
  def bench count
    @preprocessor = create_preprocessor(:simple, parallel: false)
    @preprocessor2 = create_preprocessor(:simple, parallel: true)
    @selector = create_selector(:simple, parallel: false)
    @selector2 = create_selector(:simple, parallel: true)
    classification = :function
    parameter_set = ParameterSet.new(0.0128674, 8.239002499697743e+15)
    puts "count: #{count}"
    Benchmark.bm(25) do |x|
      x.report('fetching jobs:') { @jobs = fetch_jobs(classification, count,0) }
      x.report('preprocessing:') { @data = @preprocessor.process(@jobs, classification) }
      x.report('preprocessing(p):') { @preprocessor2.process(@jobs, classification) }
      x.report('generate:') { @set = @selector.generate_vectors(@data, classification) }
      x.report('generate(p):') { @selector2.generate_vectors(@data, classification) }
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

p = PreprocessingBench.new
p.bench ARGV.first.to_i