require 'tort/download_instructions'

module Tort
  module Indprop
    class InstructionsFactory
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
            "value(n_udelenie)" => "*#{@phrase}*",
            "value(register)" => "oz",
            "value(page)" => @page_number
          }
        end
      end

      class HitDownloadInstructions < Tort::DownloadInstructions
        def initialize(url, preparse)
          @url = url
          @preparse = preparse
        end

        def url
          "http://registre.indprop.gov.sk#{@url}"
        end

        def method
          "GET"
        end
      end

      def initial_search_instructions(phrase)
        SearchDownloadInstructions.new(phrase, 1)
      end

      def hits_download_instructions_factory(phrase, cookies)
        HitDownloadInstructions
      end

      def page_download_instructions(phrase, page_number, cookies)
        SearchDownloadInstructions.new(phrase, page_number)
      end
    end
  end
end
