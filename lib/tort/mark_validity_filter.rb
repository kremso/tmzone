require 'delegate'

module Tort
  class MarkValidityFilter < SimpleDelegator
    def initialize(list_parser, valid_statuses)
      @list_parser = list_parser
      __setobj__(list_parser)
      @valid_statuses = valid_statuses
    end

    def hits_download_instructions(*args)
      @list_parser.hits_download_instructions(*args).select do |instruction|
        @valid_statuses[instruction.preparse[:status]]
      end
    end
  end
end
