#encoding: utf-8

require 'nokogiri'
require 'tort/indprop'

module Tort
  module Indprop
    class MarkParser
      def parse(html, mark)
        Nokogiri::HTML(html).search('table tr').each do |tr|
          tds = tr.search('td')
          case tds[1].text
          when 'Znenie OZ / Reprodukcia známky' then
            if (img = tds[2].search('img').first)
              mark.illustration_url = "http://registre.indprop.gov.sk#{img[:src]}"
            end
            mark.name = tds[2].text if tds[2].text != ""
          when 'Číslo zápisu' then mark.registration_number = tds[2].text
          when 'Číslo prihlášky' then mark.application_number = tds[2].text
          when 'Meno a adresa majiteľa (-ov)' then mark.owner = tds[2].text
          when 'Dátum zápisu' then mark.registration_date = Date.parse(tds[2].text)
          when 'Zoznam zatriedených tovarov a služieb' then
            nice_info = tds[2].text.gsub(".\n", ". ").gsub("\n", "").strip
            nice_info.scan(/(\d+) - (.+?\.)/) do |nice_code, nice_description|
              mark.add_class(nice_code, nice_description)
            end
          when 'Predpokladaný dátum platnosti ochrannej známky' then mark.valid_until = Date.parse(tds[2].text)
          when 'Dátum podania prihlášky' then mark.application_date = Date.parse(tds[2].text)
          when 'Právny stav OZ' then mark.status = tds[2].text
          when 'Stav' then mark.status = tds[2].text unless mark.status
          end
        end
        mark
      end
    end
  end
end
