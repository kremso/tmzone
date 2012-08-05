#encoding: utf-8
require 'tort/default_search'
require 'tort/mark_validity_filter'

require 'tort/indprop/list_parser'
require 'tort/indprop/mark_parser'
require 'tort/indprop/instructions_factory'

module Tort
  module Indprop
    VALID_STATUSES = {
      "v konaní" => true,
      "zverejnená" => true,
      "Platná" => true
    }

    def self.search(phrase, &block)
      filter = Tort::MarkValidityFilter.new(Indprop::ListParser.new, VALID_STATUSES)
      indprop = DefaultSearch.new("Indprop", filter, Indprop::MarkParser.new, Indprop::InstructionsFactory.new)
      indprop.search(phrase, &block)
    end
  end
end
