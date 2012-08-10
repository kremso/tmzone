require 'tort/search'
require 'tort/cache'
require 'tort/indprop'
require 'tort/ctm'
require 'tort/wipo'

module Tort
  class ResourceNotAvailable < StandardError; end

  def self.search(phrase, &block)
    tort = Tort::Search.new(Tort::Cache.new('indprop', Tort::Indprop),
                            Tort::Cache.new('ctm', Tort::CTM),
                            Tort::Cache.new('wipo', Tort::Wipo))
    tort.search(phrase, &block)
  end
end
