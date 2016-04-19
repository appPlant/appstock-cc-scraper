require 'basic'
require 'screener'
require 'recommendations'
require 'performance'
require 'intra_day'

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
  # @return [ Screener ] Information from thescreener.
  def screener
    @screener ||= Screener.new(@data)
  end

  # Recommendations about the stock.
  #
  # @return [ Screener ] Information about analyst recommendartions.
  def recommendations
    @recommendations ||= Recommendations.new(@data)
  end

  # Performance of the stock.
  #
  # @return [ Performance ] Informations about the performance.
  def performance
    @performance ||= Performance.new(@data)
  end

  # Price of the stock.
  #
  # @return [ IntraDay ] Informations about the price.
  def intra_day
    @price ||= IntraDay.new(@data)
  end

  alias intraday intra_day

  # Descriptive presentation of the stock instance.
  #
  # @return [ String ]
  def inspect
    "#{name} #{intraday.price} #{intraday.currency} #{intraday.performance}%"
  end
end
