require 'tort/default_search'
require 'tort/mark_validity_filter'

require 'tort/ctm/list_parser'
require 'tort/ctm/mark_parser'
require 'tort/ctm/instructions_factory'

module Tort
  module CTM
    VALID_STATUSES = {
      "Application under examination" => true,
      "Application published" => true,
      "Application opposed" => true,
      "Registered" => true,
      "Registration cancellation pending" => true,
      "CTM decision appealed" => true,
      "Conversion requested" => true,
      "CTM converted" => true,
      "Interruption of Proceedings" => true,
      "International registration accepted" => true,
      "Absolute grounds OK" => true,
      "Absolute grounds check" => true,
      "Formalities Check completed" => true,
      "Formalities check" => true,
      "Opposition period open" => true,
      "Opposition pending" => true,
      "Renewed" => true,
      "IR decision appealed" => true,
      "Opposition decision appealed" => true
    }

    def self.search(phrase, &block)
      list_parser = Tort::MarkValidityFilter.new(CTM::ListParser.new, VALID_STATUSES)
      indprop = DefaultSearch.new("CTM", list_parser, CTM::MarkParser.new, CTM::InstructionsFactory.new)
      indprop.search(phrase, &block)
    end
  end
end
