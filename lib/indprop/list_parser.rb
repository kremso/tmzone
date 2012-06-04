# encoding: utf-8

require 'nokogiri'
require 'cgi'

require 'mark'
require 'indprop/indprop'

module Indprop
  class ListParser
    def parse(html, factory = Mark)
      @doc = Nokogiri::HTML(html)
      hits = @doc.search('.listItemTitle span a').collect do |link|
        factory.new(detail_url: "#{Indprop::REGISTER_URL}#{CGI.unescape(link[:href])}")
      end
      [hits, next_page_number]
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
