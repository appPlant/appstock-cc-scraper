require_relative 'partial'

# Informations about history performance. E.g. the high, low and volume of the
# last 12 months in weekly ranges.
class PeriodPartial < Partial
  # Opening price of the time range.
  #
  # @return [ Float ]
  def first
    validate_price data[:FIRST]
  end

  # Closing price of the time range.
  #
  # @return [ Float ]
  def last
    validate_price data[:LAST]
  end

  # Highest price of the time range.
  #
  # @return [ Float ]
  def high
    validate_price data[:HIGH]
  end

  # Lowest price of the time range.
  #
  # @return [ Float ]
  def low
    validate_price data[:LOW]
  end

  # Traded volume of the time range.
  #
  # @return [ Int ]
  def volume
    data[:TOTAL_VOLUME]
  end

  # Total number in days since the end of the time period.
  #
  # @return [ Int ].
  def age
    diff_in_days data[:DATETIME_LAST]
  end

  # Volatility of that period between last and first price.
  #
  # @return [ Float ]
  def volatility
    (100 - low / high * 100).round(2) unless high == 0
  rescue
    nil
  end
end
