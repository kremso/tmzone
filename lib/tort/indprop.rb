require 'tort/default_search'

require 'tort/indprop/list_parser'
require 'tort/indprop/mark_parser'
require 'tort/indprop/instructions_factory'

module Tort
  module Indprop
    def self.search(phrase, &block)
      indprop = DefaultSearch.new("Indprop", Indprop::ListParser.new, Indprop::MarkParser.new, Indprop::InstructionsFactory.new)
      indprop.search(phrase, &block)
    end
  end
end
