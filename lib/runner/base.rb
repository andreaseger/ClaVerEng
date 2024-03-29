module Runner
  class Base
    include SvmTrainer

    def initialize(pretty: false)
      @pretty = pretty
    end
    def l msg
      puts msg
    end

    #
    # parameter search and creation of a predictor including the evaluation results
    # @param  trainer [SvmTrainer] SvmTrainer which searches for the best parameters
    # @param  feature_vectors [Array<FeatureVector>] FeatureVectors to use for the parameter search and training
    # @param  test_set [Libsvm::Problem] will be used to make the final evaluation of tha SVM model
    #
    # @return [Predictor]
    def create_predictor(trainer, feature_vectors, test_set, opts={})
      preprocessor = opts.fetch(:preprocessor) {@preprocessor}
      selector = opts.fetch(:selector) {@selector}
      classification = opts.fetch(:classification) {@classification}
      language = opts.fetch(:language) { @language }
      id = opts.fetch(:id) { nil }

      model, results, _ = trainer.search feature_vectors, (trainer.is_a?(NelderMead) ? 20 : 5 )
      predictor = SvmPredictor::Model.new(
        selector: selector,
        preprocessor: preprocessor,
        svm: model,
        classification: classification,
        trainer_class: trainer.class.to_s,
        language: language,
        properties: { samplesize: feature_vectors.size,
                      distribution: (opts[:distribution] || 1),
                      evaluator: trainer.evaluator,
                      cross_validation: trainer.number_of_folds},
        basedir: SETTINGS['basedir'],
        id: id
      )
      evaluator = Evaluator::AllInOne.new(model)
      evaluator.evaluate_dataset(test_set)
      predictor.metrics = evaluator.metrics
      predictor.save @pretty
      [predictor, results]
    end

    def get_feature_vectors(size, dictionary_size)
      jobs = fetch_jobs limit: size, original_ids: false
      data = @preprocessor.process jobs
      @selector.generate_vectors(data, dictionary_size)
    end
    def fetch_test_set *args
      create_test_problem fetch_test_data(*args)
    end

    #
    # fetch, preprocess a test set, generate feature vectors and create a libsvm Problem
    # assumes @selector already has a dictionary
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    #
    # @return [Problem] libsvm Problem
    def fetch_test_data count=10000, offset=20000
      jobs = case @language
        when 'en'
          fetch_jobs(limit: count, offset: [offset,20000].min, original_ids: false)
        when 'de','fr'
          fetch_jobs(limit: count, offset: [offset,10000].min, original_ids: false)
        end
      @preprocessor.process(jobs)
    end
    def create_test_problem data
      set = @selector.generate_vectors data
      Libsvm::Problem.new.tap{|p|
        p.set_examples( set.map(&:label),
                        set.map{|e| Libsvm::Node.features(e.data)})
      }
    end

    #
    # fetch job data with a 50/50 distribution between correct and false classification
    # @param  classification [Symbol] in `:industry`, `:function`, `:career_level`
    # @param  limit [Integer] how much jobs to get
    # @param  offset [Integer] offset the results
    # @param  language [Integer] language_id, see pjpp
    #
    # @return [Array<Hash>]
    def fetch_jobs opts={}
      opts.reverse_merge! limit: 100, offset: 0, language: language_id(@language), original_ids: true

      process_job = ->(job, index){
        id = job[:"#{@classification}_id"]
        if index.even?
          label = true
        else
          unless opts[:original_ids]
            #select a random false id
            id = CLASSIFICATION_IDS[@classification.to_sym].reject{|e| e == job[:"#{@classification}_id"]}.sample
          end
          label = false
        end
        { title: job[:title], description: job[:description], id: id, label: label }
      }

      max_count_qc=sql(QC_JOB_COUNT_SQL, opts[:language]).first[:count]

      if max_count_qc >= (opts[:limit] + opts[:offset])
        # enough jobs in QC
        sql(QC_JOB_SQL, opts[:language], opts[:limit], opts[:offset])
          .map
          .with_index(&process_job)
      else
        # not enough jobs in QC
        jobs = []
        offset = opts[:offset] - max_count_qc
        if offset < 0
          # fetch all available from QC after offset
          jobs = sql(QC_JOB_SQL, opts[:language], opts[:limit], opts[:offset])
            .map
            .with_index(&process_job)
          offset = 0
        end
        #fetch remaining jobs from expired jobs
        jobs + sql(EXPIRED_JOB_SQL,
                  opts[:language],
                  opts[:language],
                  opts[:limit]-jobs.count,
                  offset).map
                         .with_index(&process_job)
      end
    end

    # def fetch_jobs_partitioned opts={}
    #   opts.reverse_merge! limit: 100, offset: 0, language: 6, original_ids: true
    #   sql(job_sql(opts[:offset], opts[:limit]), opts[:language])
    #     .map
    #     .with_index(&process_job)
    # end

    def create_trainer(trainer, params={})
      get_trainer_klass(trainer).new({evaluator: :normalized_mcc}.merge(params))
    end
    #
    # fetch SvmTrainer class from :symbol
    # @param  trainer [Symbol]
    #
    # @return [SvmTrainer]
    def get_trainer_klass(trainer)
      case trainer
      when :linear
        Linear
      when :doe
        DoeHeuristic
      when :grid
        GridSearch
      when :nelder_mead
        NelderMead
      else
        NelderMead
      end
    end

    def create_preprocessor(preprocessor, params={})
      params = {parallel: true}.merge params
      if @classification == :industry && preprocessor == :id_map
        #TODO decouple this from Pjpp::Industry
        id_map = params.fetch(:id_map){ Hash[CLASSIFICATION_IDS[@classification].map.with_index{|e,i| [e,i]}] }
        Preprocessor::IDMapping.new(id_map, params)
      elsif preprocessor == :stemming
        Preprocessor::Stemming.new(params)
      else
        Preprocessor::Simple.new(params)
      end
    end

    def create_selector(selector, params={})
      get_selector_klass(selector).new(@classification, {parallel: true}.merge(params))
    end
    #
    # fetch Selector class from :symbol
    # @param  selector [Symbol]
    #
    # @return [Selector]
    def get_selector_klass(selector)
      case selector
      when :bns
        Selector::BiNormalSeperation
      when :ig
        Selector::InformationGain
      when :bns_ig
        Selector::BNS_IG
      else
        Selector::Simple
      end
    end

    private
    def self.sql(*args)
      # Sequel.postgres(SETTINGS['database'].merge(logger: Logger.new($stdout))) {|db| db[*args] }
      Sequel.postgres(SETTINGS['database']) {|db| db[*args] }
    end
    def sql(*args)
      self.class.sql(*args)
    end

    def language_id(code)
      sql("select id from languages where lower(code) like ?",code).first[:id]
    rescue NoMethodError
      # default to english language/jobs
      6
    end

    QC_JOB_COUNT_SQL = <<-SQL
      SELECT count(*)
        FROM jobs j
      INNER JOIN ja_qc_job_checks jc ON j.id = jc.job_id
      INNER JOIN ja_qc_check_status cs ON jc.id = cs.qc_job_check_id
      WHERE j.language_id = ?
        AND cs.check_status IS NOT NULL;
    SQL

    # language, number, qc_offset
    QC_JOB_SQL = <<-SQL
      SELECT title, description, function_id, industry_id, career_level_id
        FROM jobs j
      INNER JOIN ja_qc_job_checks jc ON j.id = jc.job_id
      INNER JOIN ja_qc_check_status cs ON jc.id = cs.qc_job_check_id
      WHERE j.language_id = ?
        AND cs.check_status IS NOT NULL
      ORDER BY jc.created_at DESC
      LIMIT ?
      OFFSET ?;
    SQL

    #language, skip_qc, number, offset_expired
    EXPIRED_JOB_SQL = <<-SQL
      SELECT title, description, function_id, industry_id, career_level_id
        FROM jobs j
      WHERE j.job_status_id = 7
        AND j.language_id = ?
        AND j.id NOT IN (SELECT jj.id
            FROM jobs jj
          INNER JOIN ja_qc_job_checks jc ON jj.id = jc.job_id
          INNER JOIN ja_qc_check_status cs ON jc.id = cs.qc_job_check_id
          WHERE jj.language_id = ?
            AND cs.check_status IS NOT NULL
          ORDER BY jc.created_at DESC )
      ORDER BY j.created_at DESC
      LIMIT ?
      OFFSET ?;
    SQL

    # generate sql select for partitioned job selection
    def job_sql(offset, limit)
      classification_count = CLASSIFICATION_IDS[@classification.to_sym].count
      partition_offset = offset/classification_count
      partition_limit = partition_offset + limit/classification_count - 1
    <<-SQL
      SELECT x.title, x.description, x.function_id, x.industry_id, x.career_level_id
      FROM (SELECT ROW_NUMBER() OVER (PARTITION BY j.function_id order by jc.created_at ASC) AS r,
        j.*,jc.created_at as jc_created_at
        FROM jobs j
        INNER JOIN ja_qc_job_checks jc ON j.id = jc.job_id
        INNER JOIN ja_qc_check_status cs ON jc.id = cs.qc_job_check_id
        WHERE j.language_id = ?) x
      WHERE x.r BETWEEN #{partition_offset} AND #{partition_limit}
      ORDER BY RANDOM();
    SQL
    end
    CLASSIFICATION_IDS = {
      function: sql(:functions).map(:id).sort,
      career_level: sql(:career_levels).map(:id).sort,
      industry: sql(:industries).map(:id).sort }
  end
end
