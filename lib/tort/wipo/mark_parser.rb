require 'nokogiri'
require 'tort/mark'

module Tort
  module Wipo
    class MarkParser
      def parse(html, mark)
        doc = Nokogiri::HTML(html)
        mark.name = cleanup(doc.search('.markname').first.text.match(/\d+ - (.*)/)[1])

        registration_number_set = false

        doc.search('.txtUp .nb').each do |heading|
          value = heading.parent.parent.search('.txtDesc').first
          case heading.text
          when "151" then
            mark.registration_date = value.text
          when "450" then
            unless registration_number_set
              mark.registration_number = cleanup(value.text.split(',').first)
              registration_number_set = true
            end
          when "540" then
            illustration = value.search('img').first
            mark.illustration_url = illustration[:src] if illustration
          when "732" then
            mark.owner = cleanup(value.search('div').first.text)
          when "821" then
            application_components = value.text.split(',')
            mark.application_number = cleanup(application_components[2])
            mark.application_date = cleanup(application_components[1])
          when "511" then
            heading.parent.parent.search('.txtDesc').each do |classification|
              nice_code = cleanup(classification.search('.txtNbRich').first.text)
              nice_description = cleanup(classification.search('.txtDescRich').first.text)
              mark.add_class(nice_code, nice_description)
            end
          when "180" then
            mark.valid_until = value.text
          end
        end

        mark
      end

      private

      def cleanup(string)
        remove_nonbreaking_space(remove_newlines(string)).strip
      end

      def remove_nonbreaking_space(string)
        string.gsub("\u00A0", "")
      end

      def remove_newlines(string)
        string.gsub("\n", "")
      end
    end
  end
end
