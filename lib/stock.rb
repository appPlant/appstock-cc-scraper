require 'basic'
require 'screener'
require 'recommendations'

# An instance indicates one finance security.
class Stock
  include Basic

  # Initializer. Each instance indicates one finance security.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    @data = data
  end

  attr_reader :data

  # Informations from thescreener about the stock.
  #
  # @return [ Screener ] An instance of class Screener.
  def screener
    @screener ||= Screener.new(@data)
  end

  # Recommendations about the stock.
  #
  # @return [ Screener ] An instance of class Recommendations.
  def recommendations
    @recommendations ||= Recommendations.new(@data)
  end
end
