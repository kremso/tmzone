require 'nokogiri'
require 'date'

module Tort
  module CTM
    class MarkParser
      def parse(html, mark)
        doc = Nokogiri::HTML(html)

        img = doc.search('#Graphic').first
        mark.illustration_url = img[:src] if img

        tds = doc.search('td')
        current = 0
        owner_name_used, nice_classification_used = false
        while current < tds.length - 1
          title = tds[current].text.strip
          value = tds[current+1].text.strip
          case title
          when "Trade mark name :" then mark.name = value
          when "Trade mark No :" then mark.application_number = value
          when "Filing date:" then mark.application_date = Date.parse(value).strftime('%d.%m.%Y')
          when "Date of registration:" then mark.registration_date = Date.parse(value).strftime('%d.%m.%Y')
          when "Nice Classification:" then
            unless nice_classification_used
              mark.classes = value.match(/(\d+)/)[1]
              nice_classification_used = true
            end
          when "List of goods and services" then mark.products_and_services = value
          when "Expiry Date:" then mark.valid_until = Date.parse(value).strftime('%d.%m.%Y')
          when "Status of trade mark:" then mark.status = tds[current+1].search('a').first.text
          when "Name:" then
            unless owner_name_used
              mark.owner = value
              owner_name_used = true
            end
          end
          current += 1
        end
        mark
      end
    end
  end
end
