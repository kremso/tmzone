require 'tort/downloader'
require 'tort/download_instructions'
require 'tort/search_results_extraction_strategy'
require 'tort/page_search'
require 'tort/serial_hits_fetcher'
require 'tort/mark_validity_filter'

require 'tort/ctm/list_parser'
require 'tort/ctm/mark_parser'

module Tort
  module CTM
    REGISTER_URL = "http://oami.europa.eu/CTMOnline/RequestManager/en_SearchBasic_NoReg"

    VALID_STATUSES = {
      "Application under examination" => true,
      "Application published" => true,
      "Application opposed" => true,
      "Registered" => true,
      "Registration cancellation pending" => true,
      "CTM decision appealed" => true,
      "Conversion requested" => true,
      "CTM converted" => true,
      "Interruption of Proceedings" => true,
      "International registration accepted" => true,
      "Absolute grounds OK" => true,
      "Absolute grounds check" => true,
      "Formalities Check completed" => true,
      "Formalities check" => true,
      "Opposition period open" => true,
      "Opposition pending" => true,
      "Renewed" => true,
      "IR decision appealed" => true,
      "Opposition decision appealed" => true
    }

    def self.search(phrase, page_number)
      params = {
        "AppliRef" => "",
        "application" => "",
        "bAdvanced" => "0",
        "bRefine" => "0",
        "bRefineModify" => "",
        "backList" => "0",
        "blimited" => "200",
        "deno" => "#{phrase}",
        "denoaux" => "#{phrase}",
        "denoselect" => "1",
        "entity" => "",
        "expirydatefrom" => "",
        "expirydateto" => "",
        "filingdatefrom" => "",
        "filingdateto" => "",
        "idappli" => "",
        "idappliSelected" => "",
        "idstatus" => "*",
        "idstatus" => "",
        "importTradeMarkId" => "",
        "importctmidscriptmethod" => "",
        "importctmidscriptmodule" => "",
        "indusage" => "",
        "language" => "en",
        "listType" => "1",
        "listTypeDate" => "",
        "markorigin" => "3",
        "niceclassificationnumber" => "",
        "ntmark" => "",
        "objIdappli" => "",
        "objRefine" => "",
        "objRefineAux" => "",
        "objSQLBasic" => "",
        "objSQLBasic2" => "",
        "objSQLOwner" => "",
        "objSQLOwner2" => "",
        "objSQLRepre" => "",
        "objSQLRepre2" => "",
        "objSearchBasic" => "",
        "owner" => "",
        "ownerselect" => "",
        "printPage" => "1",
        "pageNumber" => "#{page_number}",
        "publicationdatefrom" => "",
        "publicationdateto" => "",
        "readonly" => "",
        "registrationdatefrom" => "",
        "registrationdateto" => "",
        "representative" => "",
        "representativeselect" => "",
        "search_for_transition" => "",
        "selectOrderby" => "",
        "selectOrderby2" => "",
        "source" => "search_basic.jsp",
        "totalFound" => "",
        "transition" => "ResultsDetailed",
        "userCurrentAccount" => "",
        "userid" => ""
      }
      download_instructions = Tort::DownloadInstructions.new(url: "#{REGISTER_URL}", params: params, method: 'POST')

      hit_fetching_strategy = MarkValidityFilter.new(SerialHitsFetcher.new(Downloader, CTM::MarkParser.new), VALID_STATUSES)
      extraction_strategy = SearchResultsExtractionStrategy.new(CTM::ListParser.new, hit_fetching_strategy)

      page_search = PageSearch.new(extraction_strategy)
      page_search.search(download_instructions, Downloader)
    end
  end
end
