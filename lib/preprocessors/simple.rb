# encoding: UTF-8
require_relative 'base'
require 'ostruct'
module Preprocessor
  class Simple < Preprocessor::Base
    TITLE_FILTER = /\(m\|w\)|\(m\/w\)|,|\.|:|\*|\(|\)|!|\?|\/|·|\"|„/
    DESCRIPTION_FILTER = /<(.*?)>|(\r\n)|(,|\.|:|\*|\(|\)|!|\?|\/|·|\"|„)/
    
    def process(jobs)
      jobs.map do |job|
        OpenStruct.new(
          title: job.title.gsub(TITLE_FILTER, '').rstrip
        )
      end
    end
  end
end