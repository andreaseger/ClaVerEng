# encoding: UTF-8
require_relative 'base'
require 'ostruct'
module Preprocessor
  class Simple < Preprocessor::Base
    GENDER_FILTER = %r{(\(*(m|w)(\/|\|)(w|m)\)*)|(/-*in)|\(in\)}
    SYMBOL_FILTER = %r{/|-|–|:|\+|!|,|\.|\*|\?|/|·|\"|„|•||\|}
    WHITESPACE = /(\s| )+/
    XML_TAG_FILTER = /<(.*?)>/
    CODE_TOKEN_FILTER = /\[.*\]|\(.*\)|\{.*\}|\d+\w+/
    NEW_LINES = /(\r\n)|\r|\n/

    def process jobs, classification
      @classification = classification
      if jobs.respond_to? :map
        jobs.map{|job| process_job job }
      else
        process_job jobs
      end
    end

    def clean_title title
      title.gsub(GENDER_FILTER,'').
            gsub(SYMBOL_FILTER,'').
            gsub(/\((?<annotation>([a-zA-Z]+))\)/, '\k<annotation>').
            gsub(CODE_TOKEN_FILTER,'').
            gsub(WHITESPACE,' ').
            downcase.
            strip
    end
    def clean_description desc
      desc.gsub(XML_TAG_FILTER,' ')
          .gsub(GENDER_FILTER,'')
          .gsub(NEW_LINES,'')
          .gsub(SYMBOL_FILTER,' ')
          .gsub(WHITESPACE,' ')
          .gsub(/\((?<annotation>([a-zA-Z ]+))\)/, '\k<annotation>')
          .gsub(CODE_TOKEN_FILTER,'')
          .downcase
          .strip
    end

    private
    def process_job job
      OpenStruct.new(
        data: [ clean_title(job.title), clean_description(job.description) ],
        industry_id: job.original_industry_id,
        function_id: job.original_function_id,
        career_level_id: job.original_career_level_id,
        label: was_correct?(job)
      )
    end
  end
end
