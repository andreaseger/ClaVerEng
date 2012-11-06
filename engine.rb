require_relative 'config/environment'
require_relative 'lib/contour_display'

class ClaVerEng

  def run
    jobs = Job.double_checked.to_a
    jobs.map! do |job|
      # maybe a routine which checks various settings in one
      # run and provides all results at once
      job.preprocess.select_features.create_feature_vector
      # or something like this
      Selector(Preprocessor(job).run).to_feature_vector
    end
    training_set, cross_set, test_set, _ = job.each_slice(job.size/3).to_a

    costs = [-5, -3, -1, 0, 1, 3, 5, 8, 10, 13, 15].collect {|n| 2**n}
    gammas = [-15, -12, -8, -5, -3, -1, 1, 3, 5, 7, 9].collect {|n| 2**n}

    p "cross_validation_search"
    model, results = Svm.cross_validation_search(training_set, cross_set, costs, gammas)

    results.sort_by!{|r| [r[:gamma], r[:cost]] }
    ContourDisplay.new(costs.collect {|n| Math.log2(n)}, 
                       gammas.collect {|n| Math.log2(n)}, 
                       results.map{|r| r[:result]})
  end
  def self.run!
    new.run
  end
end

ClaVerEng.run!