require 'nokogiri'
require 'date'
require 'tort/cleanup'

module Tort
  module CTM
    class MarkParser
      include Tort::Cleanup

      def parse(html, mark)
        doc = Nokogiri::HTML(html)

        raise Tort::ResourceNotAvailable if doc.search('font.STitle1:contains("Error Report")').any?

        img = doc.search('#Graphic').first
        mark.illustration_url = img[:src] if img

        tds = doc.search('td')
        current = 0
        owner_name_used = false
        while current < tds.length - 1
          title = tds[current].text.strip
          value = cleanup(tds[current+1].text)
          case title
          when "Trade mark name :" then mark.name = value
          when "Trade mark No :" then mark.application_number = value
          when "Filing date:" then mark.application_date = Date.parse(value).strftime('%d.%m.%Y')
          when "Date of registration:" then mark.registration_date = Date.parse(value).strftime('%d.%m.%Y')
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

        section = doc.search('p.sResultHeader:contains("List of goods and services")').first
        if section
          nice_table = find_parent(section, 'table').next
          nice_table.search('tr').each do |tr|
            tds = tr.search('td')
            if tds[0].text == "Nice Classification:"
              nice_code = tds[1].text
              nice_description = tr.next.search('td')[1].text.strip
              mark.add_class(nice_code, nice_description)
            end
          end
        end

        mark
      end

      def find_parent(root, target_element_name)
        current_element = root
        begin
          current_element = current_element.parent
        end while current_element.name != target_element_name && current_element
        current_element
      end
    end
  end
end
