require 'tort/download_instructions'

module Tort
  module Indprop
    class SearchDownloadInstructions < Tort::DownloadInstructions
      def initialize(phrase, page_number)
        @phrase = phrase
        @page_number = page_number
      end

      def url
        "http://registre.indprop.gov.sk/registre/search.do"
      end

      def method
        "POST"
      end

      def params
        {
          "value(majitel)" => "#{@phrase}",
          "value(register)" => "oz",
          "value(page)" => @page_number
        }
      end
    end

    class HitDownloadInstructions < Tort::DownloadInstructions
      def initialize(url)
        @url = url
      end

      def url
        "http://registre.indprop.gov.sk#{@url}"
      end

      def method
        "GET"
      end
    end

    class PageSearch
      def initialize(downloader, list_parser)
        @downloader = downloader
        @list_parser = list_parser
      end

      def search(phrase)
        @phrase = phrase
        @next_page_instructions = SearchDownloadInstructions.new(phrase, 1)
      end

      def each_search_results_page(&block)
        page_number = 1
        while(@next_page_instructions)
          html = @downloader.download(@next_page_instructions)
          @list_parser.parse(html)
          instructions = @list_parser.hits_download_instructions(HitDownloadInstructions)
          block.call(instructions)
          page_number += 1
          @next_page_instructions = @list_parser.next_page_download_instructions(SearchDownloadInstructions.new(@phrase, page_number))
        end
      end

      def total_hits
        @list_parser.total_hits
      end
    end
  end
end
