#!/usr/bin/env ruby

require './config/environment'

def fetch_jobs(classification, limit = 100, offset = 0, language = 6)
  correct = Job.with_language(language).correct_for_classification(classification)
  correct = correct.limit(limit/2) if limit
  correct = correct.offset(offset) if offset > 0

  faulty = Job.with_language(language).correct_for_classification(classification)
  faulty = faulty.limit(limit/2) if limit
  faulty = faulty.offset(offset + limit/2)
  faulty = faulty.map { |e| e.act_as_false!; e }

  correct + faulty
end

def evaluate model, problem
  [SvmTrainer::Evaluator::AccuracyOver(0.6).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOver(0.7).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOver(0.8).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOver(0.9).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOverFalse(0.6).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOverFalse(0.7).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOverFalse(0.8).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOverFalse(0.9).new(model, true).evaluate_dataset(problem)]
end

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

id = ARGV.first
p = Predictor.find(id.to_i)

jobs = fetch_jobs(p.classification, 5000, 10000)
data = p.preprocessor.process(jobs,p.classification)
set = p.selector.generate_vectors(data, p.classification)
problem = Libsvm::Problem.new.tap{|p| p.set_examples(set.map(&:label),
                                                     set.map{|e| Libsvm::Node.features(e.data)}
                                                    )}
puts [p.id, p.classification, p.used_preprocessor, p.used_selector, p.used_trainer, p.dictionary_size, p.samplesize, p.overall_accuracy, p.geometric_mean, evaluate(p.model, problem), p.created_at].flatten
