# encoding: utf-8

require 'nokogiri'
require 'cgi'

require 'tort/indprop'
require 'tort/download_instructions'

module Tort
  module Indprop
    class ListParser
      def parse_download_instructions(html, factory = DownloadInstructions)
        @doc = Nokogiri::HTML(html)
        @doc.search('.listItem').collect do |hit|
          link = hit.search('.listItemTitle span a').first
          detail_url =  "#{Tort::Indprop::REGISTER_URL}#{CGI.unescape(link[:href])}"
          factory.new(url: detail_url, method: 'POST')
        end
      end

      def next_page_number
        current_page_number, total_pages = paging_info
        if current_page_number < total_pages
          current_page_number + 1
        else
          nil
        end
      end

      def has_next_page?
        next_page_number != nil
      end

      private

      def paging_info
        match = @doc.search('form table td').first.text.match(/Stránka (\d+) z (\d+)/)
        [match[1].to_i, match[2].to_i]
      end
    end
  end
end
