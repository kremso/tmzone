require 'nokogiri'
require 'tort/ctm/download_instructions'

module Tort
  module CTM
    class ListParser
      def parse_download_instructions(html, factory = CTM::DownloadInstructions)
        @doc = Nokogiri::HTML(html)
        @doc.search('.sResultLink').select { |a| a.text != "" }.collect do |link|
          mark_id = link["href"].match(/idappli.value='(\d+)'/)[1]
          factory.new(mark_id)
        end
      end

       def next_page_number
       end

       def has_next_page?
         @doc.search('*[title="Next 20"]').first[:src] !~ /_grey\.gif/
       end
    end
  end
end
