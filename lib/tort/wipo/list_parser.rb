require 'nokogiri'

module Tort
  module Wipo
    class ListParser
      def parse(html)
        @html = html
        @doc = Nokogiri::HTML(html)
      end

      def hits_download_instructions(factory)
        @doc.search('.table1 tbody tr td:nth-child(2) a').collect do |link|
          factory.new(url: link[:href])
        end
      end

      def next_page_download_instructions(factory)
        @doc.search('.pagination .dwn').each do |pagination_button|
          if pagination_button[:src] =~ /pict_suivant\.gif/
            link = pagination_button.parent
            return factory.new(url: link[:href])
          end
        end
        nil
      end

      def total_hits
        paging = @doc.search('.pagination td:nth-child(1)').first
        if paging
          paging.text.gsub("\u00A0", " ").match(/\((\d+) results\)/)[1].to_i
        else
          0
        end
      end
    end
  end
end
