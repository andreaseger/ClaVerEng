require './config/environment'

def fetch_jobs(classification, limit = nil, offset = nil, language = 6)
  faulty = Job.with_language(language).faulty_for_classification(classification)
  faulty = faulty.limit(limit/2) if limit
  faulty = faulty.offset(offset) if offset

  correct =  Job.with_language(language).correct_for_classification(classification).limit(faulty.size)
  correct = correct.offset(offset) if offset
  faulty + correct
end

def evaluate model, problem
  [SvmTrainer::Evaluator::AccuracyOver(0.6).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOver(0.7).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOver(0.8).new(model, true).evaluate_dataset(problem),
   SvmTrainer::Evaluator::AccuracyOver(0.9).new(model, true).evaluate_dataset(problem)]
end

require 'csv'
c=ARGV.first
jobs = fetch_jobs(c.to_sym)
CSV.open("tmp/#{c}_results.csv",'wb') do |csv|
  Predictor.where(classification: c).order('overall_accuracy desc').limit(10).each do |p|
    GC.start
    data = p.preprocessor.process(jobs,p.classification)
    set = p.selector.generate_vectors(data, p.classification)
    problem = Libsvm::Problem.new.tap{|p| p.set_examples(set.map(&:label),
                                                         set.map{|e| Libsvm::Node.features(e.data)}
                                                        )}
    csv << [p.id, p.classification, p.used_preprocessor, p.used_selector, p.used_trainer, p.dictionary_size, p.samplesize, p.overall_accuracy, p.geometric_mean, evaluate(p.model, problem), p.created_at].flatten
  end
end
