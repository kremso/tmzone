require 'tort/search'
require 'tort/indprop'
require 'tort/ctm'
require 'tort/wipo'

module Tort
  class ResourceNotAvailable < StandardError; end

  def self.search(phrase, &block)
    tort = Tort::Search.new(Tort::Indprop, Tort::CTM, Tort::Wipo)
    tort.search(phrase, &block)
  end
end
