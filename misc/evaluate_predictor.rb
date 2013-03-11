#!/usr/bin/env ruby

require './config/setup'
require 'benchmark'

require './lib/runner/base'

r = Runner::Base.new
# require 'csv'
# c=ARGV.first
# jobs = fetch_jobs(c.to_sym)
# CSV.open("tmp/#{c}_results.csv",'wb') do |csv|
#   Predictor.where(classification: c).order('overall_accuracy desc').limit(10).each do |p|
#     GC.start
#     data = p.preprocessor.process(jobs,p.classification)
#     set = p.selector.generate_vectors(data, p.classification)
#     problem = Libsvm::Problem.new.tap{|p| p.set_examples(set.map(&:label),
#                                                          set.map{|e| Libsvm::Node.features(e.data)}
#                                                         )}
#     csv << [p.id, p.classification, p.used_preprocessor, p.used_selector, p.used_trainer, p.dictionary_size, p.samplesize, p.overall_accuracy, p.geometric_mean, evaluate(p.model, problem), p.created_at].flatten
#   end
# end

p = if ARGV.empty?
      Predictor.last
    else
      id = ARGV.first
      Predictor.find(id.to_i)
    end

Benchmark.bm(15) do |x|
  x.report("fetch jobs:") { @jobs = r.fetch_jobs(p.classification, 10000, 20000) }
  x.report("preprocess:") { @data = p.preprocessor.process(@jobs,p.classification) }
  x.report("make vectors:") { @set = p.selector.generate_vectors(@data, p.classification) }
  x.report("make problem:") { @problem = Libsvm::Problem.new.tap{|p|
                              p.set_examples(@set.map(&:label),
                                             @set.map{|e| Libsvm::Node.features(e.data)}
                              )} }
  x.report("evaluate:") { @evaluator = SvmTrainer::Evaluator::AllInOne.new(p.model)
                          @evaluator.evaluate_dataset(@problem) }
end
puts "overall_accuracy: #{@evaluator.overall_accuracy}"
puts "geometric_mean: #{@evaluator.geometric_mean}"
# puts "histogram: #{@evaluator.full_histogram}"
puts "histogram: \n#{@evaluator.full_histogram.sort}"

puts [p.id, p.classification, p.used_preprocessor, p.used_selector, p.used_trainer, p.dictionary_size, p.samplesize, p.created_at, p.gamma, p.cost].flatten
