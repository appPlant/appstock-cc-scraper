require 'json'
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
        '1w': performance.of(1, :week),
        '4w': performance.of(4, :weeks),
        '52w': performance.of(52, :weeks),
        cy: performance.of(:current, :year),
        '3y': performance.of(3, :years),
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
      },
      trading_central: {
        pivot: trading_central.pivot,
        support: trading_central.support_levels,
        resistance: trading_central.resistance_levels,
        short_term: trading_central.short_term_potential,
        medium_term: trading_central.medium_term_potential,
        updated_at: trading_central.updated_at
      },
      risk: {
        bad_news_factor: risk.bad_news_factor,
        bear_market_factor: risk.bear_market_factor,
        beta: risk.beta,
        volatility: { '1': risk.volatility(1), '12': risk.volatility(12) },
        correlation: risk.correlation,
        capitalization: risk.capitalization
      },
      chance: {
        dividend: chance.dividend,
        earnings_revision: chance.earnings_revision,
        earnings_trend: chance.earnings_trend,
        long_term: chance.long_term_potential,
        long_term_per: chance.long_term_per,
        medium_term_technical_trend: chance.medium_term_technical_trend,
        analysts: chance.analysts,
        relative_performance: chance.relative_performance,
        technical_reverse_price: chance.technical_reverse_price,
        currency: chance.currency,
        rating: chance.rating
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
