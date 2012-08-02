require 'tort/default_search'

require 'tort/ctm/list_parser'
require 'tort/ctm/mark_parser'
require 'tort/ctm/instructions_factory'

module Tort
  module CTM
    def self.search(phrase, &block)
      indprop = DefaultSearch.new("CTM", CTM::ListParser.new, CTM::MarkParser.new, CTM::InstructionsFactory.new)
      indprop.search(phrase, &block)
    end
  end
end
