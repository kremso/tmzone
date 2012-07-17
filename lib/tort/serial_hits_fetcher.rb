require 'tort/mark'

module Tort
  class SerialHitsFetcher
    def initialize(downloader, mark_parser)
      @downloader = downloader
      @mark_parser = mark_parser
    end

    attr_reader :hits

    def fetch_hits(download_instructions, factory = Mark)
      @hits = download_instructions.collect do |download_instruction|
        begin
          html = @downloader.download(download_instruction)
          @mark_parser.parse(html, factory.new)
        rescue Tort::ResourceNotAvailable
          factory.new(incomplete: true, name: download_instruction.name)
        end
      end
    end
  end
end
