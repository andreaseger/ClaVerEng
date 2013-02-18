require './config/environment'

def fetch_jobs(classification, limit = nil, offset = nil, language = 6)
  faulty = Job.with_language(language).faulty_for_classification(classification)
  faulty = faulty.limit(limit/2) if limit
  faulty = faulty.offset(offset) if offset

  correct =  Job.with_language(language).correct_for_classification(classification).limit(faulty.size)
  correct = correct.offset(offset) if offset
  faulty + correct
end

jobs={function: fetch_jobs(:function),industry: fetch_jobs(:industry), career_level: fetch_jobs(:career_level)}

require 'csv'
c=ARGV.first
CSV.open("tmp/reeval_#{c}_results.xls",'wb',col_sep: "\t") do |csv|
  Predictor.where(classification: c).all.each do |p|
    data = p.preprocessor.process(jobs[p.classification.to_sym],p.classification)
    set = p.selector.generate_vectors(data, p.classification)
    problem = Libsvm::Problem.new.tap{|p| p.set_examples(set.map(&:label), set.map{|e| Libsvm::Node.features(e.data)})}
    more_over = [SvmTrainer::Evaluator::AccuracyOver(0.6).new(p.model, true).evaluate_dataset(problem),
                 SvmTrainer::Evaluator::AccuracyOver(0.7).new(p.model, true).evaluate_dataset(problem),
                 SvmTrainer::Evaluator::AccuracyOver(0.8).new(p.model, true).evaluate_dataset(problem),
                 SvmTrainer::Evaluator::AccuracyOver(0.9).new(p.model, true).evaluate_dataset(problem)]
    csv << [p.id, p.classification, p.used_preprocessor, p.used_selector, p.used_trainer, p.dictionary_size, p.samplesize, p.overall_accuracy, p.geometric_mean, more_over, p.created_at].flatten
  end
end


