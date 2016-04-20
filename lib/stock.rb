require 'oj'
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

  # Availability of the stock on cortal consors.
  #
  # @return [ Boolean ] A true value means available on that platform.
  def available?
    @data && !name.nil?
  end

  # JSON representation of the stock instance.
  #
  # @return [ String ] JSON encoded string.
  def to_json
    data = {
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
        high: intra.highest_price,
        low: intra.lowest_price,
        performance: intra.performance,
        volume: intra.volume,
        updated_at: intra.updated_at
      },
      performance: {
        w_1: performance.w_1,
        w_4: performance.w_4,
        w_52: performance.w_52,
        w_52_high: performance.w_52_high,
        w_52_low: performance.w_52_low,
        w_52_high_at: performance.w_52_high_at,
        w_52_low_at: performance.w_52_low_at,
        y_3: performance.y_3,
        y_c: performance.y_c
      },
      recommendations: {
        count: recommendations.count,
        upgrades: recommendations.upgrades,
        downgrades: recommendations.downgrades,
        consensus: recommendations.consensus,
        target_price: recommendations.target_price,
        currency: recommendations.currency,
        expected_performance: recommendations.expected_performance,
        recent: recommendations.recent,
        last_quarter: recommendations.last_quarter,
        updated_at: recommendations.updated_at
      }
    }

    Oj.dump(data, symbol_keys: false)
  end

  # Descriptive presentation of the stock instance.
  #
  # @return [ String ]
  def inspect
    "#{name} #{intraday.price} #{intraday.currency} #{intraday.performance}%"
  end
end
