# encoding: utf-8

require 'nokogiri'
require 'cgi'

require 'tort/indprop'
require 'tort/download_instructions'

module Tort
  module Indprop
    class ListParser
      def parse(html)
        @doc = Nokogiri::HTML(html)
      end

      def hits_download_instructions(factory)
        @doc.search('.listItem').collect do |hit|
          link = hit.search('.listItemTitle span a').first
          detail_url = CGI.unescape(link[:href])
          factory.new(detail_url)
        end
      end

      def next_page_download_instructions(instructions)
        instructions if next_page_number
      end

      def total_hits
        @doc.search('form table td')[3].text.match(/Počet záznamov: (\d+)/)[1].to_i
      end

      private

      def next_page_number
        current_page_number, total_pages = paging_info
        if current_page_number < total_pages
          current_page_number + 1
        else
          nil
        end
      end

      def paging_info
        match = @doc.search('form table td').first.text.match(/Stránka (\d+) z (\d+)/)
        [match[1].to_i, match[2].to_i]
      end
    end
  end
end
