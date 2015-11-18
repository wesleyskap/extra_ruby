require 'rest-client'
require 'pry'
require "extra/base"
require "extra/item"
require "extra/order"
require "extra/product"
require "extra/version"
require "json"

module Extra
  def self.config!(config)
    @config = config
  end

  def self.config
    @config
  end
end
