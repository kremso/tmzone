require 'tort/download_instructions'

module Tort
  module CTM
    class InstructionsFactory
      def initial_search_instructions(phrase)
        SearchDownloadInstructions.new(phrase, 1)
      end

      def hits_download_instructions_factory(phrase, cookies)
        HitsDownloadInstructionsFactory.new(phrase)
      end

      def page_download_instructions(phrase, page_number, cookies)
        SearchDownloadInstructions.new(phrase, page_number)
      end
    end

    class SearchDownloadInstructions < Tort::DownloadInstructions
      def initialize(phrase, page)
        @phrase = phrase
        @page = page
      end

      def url
        "http://oami.europa.eu/CTMOnline/RequestManager/en_Result_NoReg"
      end

      def method
        'POST'
      end

      def params
        {
          "AppliRef" => "",
          "application" => "",
          "bAdvanced" => "0",
          "bRefine" => "0",
          "bRefineModify" => "",
          "backList" => "0",
          "blimited" => "200",
          "deno" => "#{@phrase}",
          "denoaux" => "#{@phrase}",
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
          "pageNumber" => "#{@page}",
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
      end
    end

    class HitDownloadInstructions < Tort::DownloadInstructions
      def initialize(phrase, type, mark_id)
        @phrase = phrase
        @type = type
        @mark_id = mark_id
      end

      def url
        "http://oami.europa.eu/CTMOnline/RequestManager/en_Detail#{@type}_NoReg"
      end

      def cookies
        nil
      end

      def method
        "POST"
      end

      def params
        {
          "AppliRef" => "",
          "application" => "CTMOnline",
          "bAdvanced" => "0",
          "bRefine" => "0",
          "bRefineModify" => "0",
          "backList" => "0",
          "blimited" => "200",
          "dateRecOHIM" => "28/03/1996",
          "deno" => "#{@phrase}",
          "denoSave" => "#{@phrase}",
          "denoselect" => "1",
          "expirydatefrom" => "",
          "expirydateto" => "",
          "filingdatefro" => "",
          "filingdateto" => "",
          "idappli" => "#{@mark_id}",
          "idappliSelected" => "",
          "idcategor" => "",
          "idstatus" => "",
          "idxidappli" => "33",
          "importTradeMarkId" => "",
          "importctmidscriptmethod" => "",
          "importctmidscriptmodule" => "",
          "indusage" => "",
          "intMaxDocsFound" => "54",
          "language" => "en",
          "listType" => "1",
          "listTypeDate" => "",
          "markorigin" => "3",
          "namesearch2" => "",
          "niceclassificationnumber" => "",
          "ntmar" => "",
          "objDeno" => "",
          "objIdappli" => "",
          "objMarkOrigin" => "",
          "objRefine" => "",
          "objSQLBasic" => "",
          "objSQLBasic2" => "",
          "objSQLOwner" => "not+Applicable+any+More",
          "objSQLOwner2" => "not+Applicable+any+More",
          "objSQLRepre" => "not+Applicable+any+More",
          "objSQLRepre2" => "not+Applicable+any+More",
          "objSearchBasic" => "|$@|1|#{@phrase}|$@|$@|1|1|2|$@|$@|$@|$@|$@|$@|$@|$@|$@|$@|200|$@|2|3|$@|$@|$@|$@|$@|$@",
          "owner" => "",
          "ownerSave" => "$@",
          "ownerselect" => "",
          "pageNumber" => "1",
          "printPage" => "",
          "publicationdatefrom" => "",
          "publicationdateto" => "",
          "readonly" => "",
          "refreshOrderList" => "0",
          "registrationdatefrom" => "",
          "registrationdateto" => "",
          "representative" => "",
          "representativeSave" => "$@",
          "representativeselect" => "",
          "searchParameters" => "",
          "search_for_transition" => "",
          "searchname" => "",
          "selectOrderby" => "1",
          "selectOrderby2" => "2",
          "source" => "results_detailed.jsp",
          "stExpandTree" => "false",
          "totalFound" => "54",
          "transition" => "DetailedTrademarkInformation",
          "userCurrentAccount" => "",
          "user" => ""
        }
      end
    end

    class HitsDownloadInstructionsFactory
      def initialize(phrase)
        @phrase = phrase
      end

      def new(params)
        HitDownloadInstructions.new(@phrase, params[:type], params[:mark_id])
      end
    end
  end
end
