require 'nokogiri'
require 'tort/cleanup'

module Tort
  module CTM
    class ListParser
      include Tort::Cleanup

      def parse(html)
        @doc = Nokogiri::HTML(html)
        @search_results_tables = @doc.search("//table[.//*[contains(concat(' ', @class, ' '), ' sResultLink ')]]").slice(3..-1)
      end

      def hits_download_instructions(factory)
        return [] unless @search_results_tables
        @search_results_tables.collect do |table|
          link = table.search('.sResultLink:not(:empty)').first
          mark_id = link["href"].match(/ctmSubmit\.idappli\.value='(.+?)'/)[1]
          mark_type_id = link["href"].match(/DetailedTrademark\('(\d)'\)/)[1]
          mark_type = case mark_type_id.to_i
          when 0 then 'CTM'
          when 1 then 'IA'
          when 2 then 'IR'
          end
          name = cleanup(link.text)
          status_td = table.search('.sResultName:contains("Status:")').first
          status = status_td.search('font').first.text
          factory.new(mark_type, mark_id, {status: status, name: name})
        end
      end

      def next_page_download_instructions(instructions)
        instructions if has_next_page?
      end

      def total_hits
        @doc.search('.sSubTitle2').each do |title|
          match = title.text.match(/Search results: Found (\d+)/)
          return match[1].to_i if match
        end
      end

      private

      def has_next_page?
        if @search_results_tables
          @doc.search('*[title="Next 20"]').first[:src] !~ /_grey\.gif/
        else
          false
        end
      end
    end
  end
end
