require 'tort/mark'

module Tort
  class ParallelHitsFetcher
    def initialize(downloader, mark_parser)
      @downloader = downloader
      @mark_parser = mark_parser
    end

    attr_reader :hits

    def fetch_hits(download_instructions, factory = Mark)
      marks = []
      threads = []
      semaphore = Mutex.new
      download_instructions.each do |download_instruction|
        threads << Thread.new do
          mark = fetch(download_instruction, factory)
          semaphore.synchronize { marks << mark }
        end
      end

      threads.each(&:join)
      marks
    end

    private

    def fetch(download_instruction, factory)
      begin
        html = @downloader.download(download_instruction)
        @mark_parser.parse(html, factory.new)
      rescue Tort::ResourceNotAvailable
        factory.new(incomplete: true, name: "N/A") # TODO
      end
    end
  end
end
