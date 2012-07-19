# encoding: utf-8
require 'tort/download_instructions'

module Tort
  module CTM
    class DownloadInstructions < Tort::DownloadInstructions
      def initialize(mark_id)
        @mark_id = mark_id
      end

      def url
        "http://oami.europa.eu/CTMOnline/RequestManager/en_DetailCTM_NoReg"
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
          "deno" => "pepsi",
          "denoSave" => "pepsi",
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
          "objSearchBasic" => "|$@|1|pepsi|$@|$@|1|1|2|$@|$@|$@|$@|$@|$@|$@|$@|$@|$@|200|$@|2|3|$@|$@|$@|$@|$@|$@",
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
  end
end
