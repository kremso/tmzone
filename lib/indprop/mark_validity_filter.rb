# encoding: utf-8

module Indprop
  class MarkValidityFilter
    def initialize(decorated_fetcher)
      @decorated_fetcher = decorated_fetcher
    end

    VALID_STATUSES = {
        "v konaní" => true,
        "zverejnená" => true,
        "Platná" => true
    }

    def fetch(*args)
      marks, next_page = @decorated_fetcher.fetch(*args)
      filtered_marks = marks.select do |mark|
        VALID_STATUSES[mark.status]
      end
      [filtered_marks, next_page]
    end
  end
end
