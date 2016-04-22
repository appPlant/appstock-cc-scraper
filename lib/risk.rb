# Informations from thescreener about the risk of the stock.
class Risk
  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    @data = data.fetch(:ScreenerAnalysisV1, {})[:RISK] || {}
  end

  # The value of the bad-news-factor.
  #
  # @return [ Int ]
  def bad_news_factor
    value_of :BAD_NEWS_FACTOR
  end

  # The value of the bear-market-factor.
  #
  # @return [ Int ]
  def bear_market_factor
    value_of :BEAR_MARKET_FACTOR
  end

  # The beta value.
  #
  # @return [ Int ]
  def beta
    value_of :BETA
  end

  # The volatility for the specified time of months.
  #
  # @param [ Int ] value Supported values are 1 and 12.
  # @param [ Symbol] unit Supported values are :months
  #
  # @return [ Float ]
  def volatility(value = 1, unit = :months)
    raise "Unsupported unit #{unit} for volatility" if unit !~ /^months?/i

    case value
    when 1  then value_of(:VOLATILITY_1M)
    when 12 then value_of(:VOLATILITY_12M)
    else raise "Unsupported value #{unit} for volatility"
    end
  end

  # The correlation in % with its index.
  #
  # @return [ Float ]
  def correlation
    value_of :CORRELATION
  end

  # The market capitalization in billion dollar.
  #
  # @return [ Float ]
  def capitalization
    value_of :MARKET_CAPITALIZATION
  end

  private

  # Find the value for the given key.
  #
  # @param [ Symbol ] key
  #
  # @return [ Object ]
  def value_of(key)
    @data[key][:VALUE]
  rescue
    nil
  end
end
