require 'tort/download_instructions'

module Tort
  module Wipo
    class PageSearch
      class DownloadInstructionsFactory
        def initialize(sessionid, cookies)
          if cookies =~ /JSESSIONID/
            @cookies = cookies
          else
            @cookies = "JSESSIONID=#{sessionid}; #{cookies}"
          end
        end

        def new(params)
          params.merge!(cookies: @cookies, method: 'GET')
          params[:url] = "http://www.wipo.int#{params[:url]}"
          Tort::DownloadInstructions.new(params)
        end
      end

      def initialize(downloader, list_parser)
        @downloader = downloader
        @list_parser = list_parser
      end

      def search(phrase)
        instructions = DownloadInstructions.new(url: "http://www.wipo.int/romarin", method: "GET")
        @downloader.download(instructions)
        initial_cookies = @downloader.response_cookies

        @sessionid = initial_cookies.match(/JSESSIONID=(.+?);/)[1]

        @next_page_instructions =
          DownloadInstructions.new(url: "http://www.wipo.int/romarin/searchAction.do;jsessionid=#{@sessionid}",
                                   method: "POST",
                                   params: search_params(phrase),
                                   cookies: initial_cookies)
      end

      def each_search_results_page(factory = DownloadInstructionsFactory, &block)
        while(@next_page_instructions)
          html = @downloader.download(@next_page_instructions)
          @list_parser.parse(html)
          instructions_factory = factory.new(@sessionid, @downloader.response_cookies)
          instructions = @list_parser.hits_download_instructions(instructions_factory)
          block.call(instructions)
          @next_page_instructions = @list_parser.next_page_download_instructions(instructions_factory)
        end
      end

      def total_hits
        @list_parser.total_hits
      end

      private

      def search_params(phrase)
        {
          "cbValidationSearch" => "fromSearchPage",
          "lines[0].operator" => "AND",
          "lines[0].singleSelect" => "HOL",
          "lines[0].term" => "",
          "lines[10].operator" => "AND",
          "lines[10].singleSelect" => "OBR",
          "lines[10].term" => "",
          "lines[11].operator" => "AND",
          "lines[11].singleSelect" => "DSA",
          "lines[11].term" => "",
          "lines[12].operator" => "AND",
          "lines[12].singleSelect" => "OBD",
          "lines[12].term" => "",
          "lines[1].operator" => "AND",
          "lines[1].singleSelect" => "REP",
          "lines[1].term" => "",
          "lines[2].operator" => "AND",
          "lines[2].singleSelect" => "MAR",
          "lines[2].term" => "#{phrase}",
          "lines[3].operator" => "AND",
          "lines[3].singleSelect" => "VC",
          "lines[3].term" => "",
          "lines[4].operator" => "AND",
          "lines[4].singleSelect" => "NCL",
          "lines[4].term" => "",
          "lines[5].operator" => "AND",
          "lines[5].singleSelect" => "GSE",
          "lines[5].term" => "",
          "lines[6].operator" => "AND",
          "lines[6].singleSelect" => "GSF",
          "lines[6].term" => "",
          "lines[7].operator" => "AND",
          "lines[7].singleSelect" => "GSS",
          "lines[7].term" => "",
          "lines[8].operator" => "AND",
          "lines[8].singleSelect" => "ORI",
          "lines[8].term" => "sk or em",
          "lines[9].operator" => "AND",
          "lines[9].singleSelect" => "OBA",
          "lines[9].term" => "",
          "order" => "ID",
          "searchDatabaseAct" => "on",
          "singleSelect" => "IRN",
          "sizeSearch" => "25",
          "submit" => "Search",
          "term" => "",
          "typeAction" => "0"
        }
      end
    end
  end
end
