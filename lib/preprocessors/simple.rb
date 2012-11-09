# encoding: UTF-8
require_relative 'base'
require 'ostruct'
module Preprocessor
  class Simple < Preprocessor::Base
    GENDER_FILTER = %r{(\(*(m|w)(\/|\|)(w|m)\)*)|(/-*in)|\(in\)}
    SYMBOL_FILTER = %r{/|-|–|:|\+|!}
    WHITESPACE = %r{\s+}
    DESCRIPTION_FILTER = /<(.*?)>|(\r\n)|(,|\.|:|\*|\(|\)|!|\?|\/|·|\"|„)/
    
    def process(jobs)
      jobs.map do |job|
        OpenStruct.new(
          title: job.title.gsub(GENDER_FILTER, '')
                          .gsub(SYMBOL_FILTER,'')
                          .gsub(%r{\(*\d+%*\)*},'')
                          #.gsub(%r{\((<content>\w)\)},"")s.gsub(/(?<foo>[aeiou])/, '{\k<foo>}')
                          .gsub(WHITESPACE,' ').strip
        )
      end
    end
  end
end