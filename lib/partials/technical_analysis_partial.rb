require_relative 'partial'

# Informations about the technical analysis of the stock.
class TechnicalAnalysisPartial < Partial
  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    super data[:TechnicalAnalysisV1] || {}
  end

  # The value of the Moving Average Convergence Divergence (MACD) incidator.
  #
  # @return [ Int] 0 means bearish, 1 means bullish.
  def macd
    data[:MACD]
  end

  # The momentum indicator of a time period.
  #
  # @param [ Int ] days Supported values are 20, 50, 250 and 'trend'.
  #
  # return [ Int ] A value between -1 and 1.
  def momentum(days = 20)
    case days
    when 20     then data[:MOMENTUM_20]
    when 50     then data[:MOMENTUM_50]
    when 250    then data[:MOMENTUM_250]
    when :trend then data[:MOMENTUM_TREND]
    else raise "Unsupported time frame #{days} for momentum"
    end
  end

  # The RSI indicator of a time period.
  #
  # @param [ Int ] days Supported values are 5, 20, 250 and 'trend'.
  #
  # return [ Int ] A value between -1 and 1.
  def rsi(days = 5)
    case days
    when 5      then data[:RSI_5]
    when 20     then data[:RSI_20]
    when 250    then data[:RSI_250]
    when :trend then data[:RSI_TREND]
    else raise "Unsupported time frame #{days} for rsi"
    end
  end

  # The moving average of a time period.
  #
  # @param [ Int ] days Supported values are 5, 20, 200 and 'trend'.
  #
  # return [ Int ] A value between -1 and 1.
  def moving_average(days = 5)
    case days
    when 5      then data[:MOVING_AVERAGE_5]
    when 20     then data[:MOVING_AVERAGE_20]
    when 200    then data[:MOVING_AVERAGE_200]
    when :trend then data[:MOVING_AVERAGE_TREND]
    else raise "Unsupported time frame #{days} for moving_average"
    end
  end
end
