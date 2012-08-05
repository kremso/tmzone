module Tort
  class DownloadInstructions
    attr_accessor :url, :cookies, :params, :method, :preparse

    def initialize(options)
      options.each do |k, v|
        send("#{k}=", v)
      end
    end
  end
end
