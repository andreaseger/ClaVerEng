require 'sinatra/base'
require 'config/environment'

class PredictorApi < Sinatra::Base
  CLASSIFICATIONS = %w(function career_level industry)

  get '/' do
    Predictor.all.to_a
  end
  CLASSIFICATIONS.each do |classification|
    get "/#{classification}/:job_id" do |id, job_id|
      Predictor.where(classification: classification).order(:overall_accuracy).last.predict_job_id(job_id)
    end
  end
end

