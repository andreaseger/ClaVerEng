require_relative 'preprocessor'
module Preprocessor
  class Simple < Preprocessor::Base
    TITLE_FILTER = /,|\.|:|\*|\(|\)|!|\?|\/|·|\"|„|\(m\|w\)/
    DESCRIPTION_FILTER = /<(.*?)>|(\r\n)|(,|\.|:|\*|\(|\)|!|\?|\/|·|\"|„)/
  end
end