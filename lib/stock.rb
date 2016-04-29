require 'basic'
require 'screener'
require 'recommendations'
require 'performance'
require 'intra_day'
require 'technical_analysis'
require 'trading_central'
require 'risk'
require 'chance'

# Each instance of class Stock indicates one finance security. The provided
# informations are reaching from basic properties like name and ISIN over
# intraday stats up to analyst recommendations and technical analysis results.
#
# @example Initializing a stock.
#   stock = Stock.new(properties-from-consorsbank)
#
# @example Accessing the WKN code.
#   stock.wkn
#   #=> A1JWVX
#
# @example Get todays performance.
#   stock.intra.performance
#   #=> -1.59
#
# @example Convert the stock into a JSON structure
#   stock.to_json
#   #=> "{...}"
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
  # @return [ Screener ]
  def screener
    @screener ||= Screener.new(@data)
  end

  # Recommendations about the stock.
  #
  # @return [ Recommendations ]
  def recommendations
    @recommendations ||= Recommendations.new(@data)
  end

  # Performance of the stock.
  #
  # @return [ Performance ]
  def performance
    @performance ||= Performance.new(@data)
  end

  # Price of the stock.
  #
  # @return [ IntraDay ]
  def intra
    @intra ||= IntraDay.new(@data)
  end

  # Technical figures of the stock.
  #
  # @return [ TechnicalAnalysis ]
  def technical_analysis
    @technical_analysis ||= TechnicalAnalysis.new(@data)
  end

  # Technical figures of the stock from tradingcentral.
  #
  # @return [ TradingCentral ]
  def trading_central
    @trading_central ||= TradingCentral.new(@data)
  end

  # Risk figures of the stock from thescreener.
  #
  # @return [ Risk ]
  def risk
    @risk ||= Risk.new(@data)
  end

  # Outlook figures of the stock from thescreener.
  #
  # @return [ Chance ]
  def chance
    @chance ||= Chance.new(@data)
  end

  # Availability of the stock on cortal consors.
  #
  # @return [ Boolean ] A true value means available on that platform.
  def available?
    @data && isin
  end

  # Descriptive presentation of the stock instance.
  #
  # @return [ String ]
  def inspect
    "#{name} #{intra.price} #{intra.currency} #{intra.performance}%"
  end
end
