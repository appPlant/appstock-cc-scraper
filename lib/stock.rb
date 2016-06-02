require 'partials/basic_partial'
require 'partials/screener_partial'
require 'partials/recommendation_partial'
require 'partials/performance_partial'
require 'partials/intra_day_partial'
require 'partials/technical_analysis_partial'
require 'partials/trading_central_partial'
require 'partials/risk_partial'
require 'partials/chance_partial'
require 'partials/events_partial'
require 'partials/history_partial'

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
  include BasicPartial

  # Initializer. Each instance indicates one finance security.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  # @param [ String ] url The URL where the data comes from.
  #
  # @return [ Stock ]
  def initialize(data, url = nil)
    @url  = url
    @data = data
  end

  attr_reader :data, :url

  alias exec instance_exec

  # Informations from thescreener about the stock.
  #
  # @return [ Screener ]
  def screener
    @screener ||= ScreenerPartial.new(@data)
  end

  # Recommendations about the stock.
  #
  # @return [ Recommendations ]
  def recommendations
    @recommendations ||= RecommendationPartial.new(@data)
  end

  # Performance of the stock.
  #
  # @return [ Performance ]
  def performance
    @performance ||= PerformancePartial.new(@data)
  end

  # Price of the stock.
  #
  # @return [ IntraDay ]
  def intra
    @intra ||= IntraDayPartial.new(@data)
  end

  # Technical figures of the stock.
  #
  # @return [ TechnicalAnalysis ]
  def technical_analysis
    @technical_analysis ||= TechnicalAnalysisPartial.new(@data)
  end

  # Technical figures of the stock from tradingcentral.
  #
  # @return [ TradingCentral ]
  def trading_central
    @trading_central ||= TradingCentralPartial.new(@data)
  end

  # Risk figures of the stock from thescreener.
  #
  # @return [ Risk ]
  def risk
    @risk ||= RiskPartial.new(@data)
  end

  # Outlook figures of the stock from thescreener.
  #
  # @return [ Chance ]
  def chance
    @chance ||= ChancePartial.new(@data)
  end

  # Outlook figures of the stock.
  #
  # @return [ Chance ]
  def events
    @events ||= EventsPartial.new(@data)
  end

  # History performance figures of the stock.
  #
  # @return [ Chance ]
  def history
    @history ||= HistoryPartial.new(@data, @url)
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
