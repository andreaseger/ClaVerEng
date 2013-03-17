#!/usr/bin/env ruby

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../..'))
require 'config/setup'
require 'lib/runner/base'

class Eval < Runner::Base
  def self.run
    new.run
  end
  def run
    file = Dir[SETTINGS['basedir'] + '/*.json'].sort.last

    p = SvmPredictor::Model.load_file file
    @classification = p.classification.to_sym

    jobs = fetch_jobs(10000, 20000)
    data = p.preprocessor.process(jobs)
    set = p.selector.generate_vectors(data)
    problem = Libsvm::Problem.new.tap{|p|
                p.set_examples(set.map(&:label),
                               set.map{|e| Libsvm::Node.features(e.data)}
                )}
    evaluator = SvmTrainer::Evaluator::AllInOne.new(p.svm)
    evaluator.evaluate_dataset(problem)
    puts "overall_accuracy: #{evaluator.overall_accuracy}"
    puts "geometric_mean: #{evaluator.geometric_mean}"
    puts "histogram: #{evaluator.full_histogram}"

    p p.serializable_hash.slice(:id, :classification, :properties, :metrics, :trainer_class, :preprocessor_class, :selector_class)
  end
end

Eval.run