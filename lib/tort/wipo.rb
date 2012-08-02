require 'tort/default_search'

require 'tort/wipo/list_parser'
require 'tort/wipo/mark_parser'
require 'tort/wipo/instructions_factory'

module Tort
  module Wipo
    def self.search(phrase, &block)
      indprop = DefaultSearch.new("WIPO", Wipo::ListParser.new, Wipo::MarkParser.new, Wipo::InstructionsFactory.new)
      indprop.search(phrase, &block)
    end
  end
end
