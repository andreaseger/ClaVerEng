require './config/environment'
require './lib/preprocessors/simple'
require './lib/selectors/simple'
require './lib/selectors/n_gram'
p = Predictor.last
j = Job.with_language(5).checked.offset(5000).limit(1).first
p.predict_job j
