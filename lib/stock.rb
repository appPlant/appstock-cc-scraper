require 'json'
require 'basic'
require 'screener'
require 'recommendations'
require 'performance'
require 'intra_day'
require 'technical_analysis'

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
  # @return [ Screener ] Information from thescreener.
  def screener
    @screener ||= Screener.new(@data)
  end

  # Recommendations about the stock.
  #
  # @return [ Screener ] Information about analyst recommendations.
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
  alias intra    intra_day

  # Technical figures of the stock.
  #
  # @return [ IntraDay ] Informations about the technical analysis.
  def technical_analysis
    @technical_analysis ||= TechnicalAnalysis.new(@data)
  end

  # Availability of the stock on cortal consors.
  #
  # @return [ Boolean ] A true value means available on that platform.
  def available?
    @data && isin
  end

  # JSON representation of the stock instance.
  #
  # @return [ String ] JSON encoded string.
  def to_json
    data = {
      source: :consorsbank,
      created_at: Time.now,
      version: 1,
      basic: { name: name, wkn: wkn, isin: isin, symbol: symbol },
      screener: {
        per: screener.per,
        risk: screener.risk,
        interest: screener.interest,
        updated_at: screener.updated_at
      },
      intra: {
        price: intra.price,
        currency: intra.currency,
        high: intra.high,
        low: intra.low,
        performance: intra.performance,
        volume: intra.volume,
        realtime: intra.realtime?,
        updated_at: intra.updated_at
      },
      performance: {
        weeks: {
          '1': performance.of(1, :week),
          '4': performance.of(4, :weeks),
          '52': performance.of(52, :weeks)
        },
        years: {
          current: performance.of(:current, :year),
          '3': performance.of(3, :years)
        },
        high: { price: performance.high, at: performance.high_at },
        low: { price: performance.low, at: performance.low_at }
      },
      recommendations: {
        count: recommendations.count,
        upgrades: recommendations.upgrades,
        downgrades: recommendations.downgrades,
        consensus: recommendations.consensus,
        target_price: {
          value: recommendations.target_price,
          currency: recommendations.currency
        },
        expected_performance: recommendations.expected_performance,
        recent: recommendations.recent,
        last_quarter: recommendations.last_quarter,
        updated_at: recommendations.updated_at
      },
      technical_analysis: {
        macd: technical_analysis.macd,
        momentum: {
          '20': technical_analysis.momentum(20),
          '50': technical_analysis.momentum(50),
          '250': technical_analysis.momentum(250),
          trend: technical_analysis.momentum(:trend)
        },
        moving_average: {
          '5': technical_analysis.moving_average(5),
          '20': technical_analysis.moving_average(20),
          '200': technical_analysis.moving_average(200),
          trend: technical_analysis.moving_average(:trend)
        },
        rsi: {
          '5': technical_analysis.rsi(5),
          '20': technical_analysis.rsi(20),
          '250': technical_analysis.rsi(250),
          trend: technical_analysis.rsi(:trend)
        }
      }
    }

    JSON.fast_generate(data, symbolize_names: false)
  end

  # Descriptive presentation of the stock instance.
  #
  # @return [ String ]
  def inspect
    "#{name} #{intra.price} #{intra.currency} #{intra.performance}%"
  end
end
