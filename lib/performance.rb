# Informations about the performance of a stock.
class Performance
  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    @data = data[:PerformanceV1] || {}
  end

  # The performance of the last week in %.
  #
  # @return [ Float ]
  def w_1
    value_for :PERFORMANCE_PCT_W1
  end

  # The performance of the last month in %.
  #
  # @return [ Float ]
  def m_1
    value_for :PERFORMANCE_PCT_W4
  end

  alias w_4 m_1

  # The performance of the last 52 weeks in %.
  #
  # @return [ Float ]
  def w_52
    value_for :PERFORMANCE_PCT_W52
  end

  # The performance of the last 3 years in %.
  #
  # @return [ Float ]
  def y_3
    value_for :PERFORMANCE_PCT_Y3
  end

  # The performance of the recent year in %.
  #
  # @return [ Float ]
  def y_c
    value_for :PERFORMANCE_PCT_CY
  end

  alias current_year y_c

  # The highest price within the last 52 weeks.
  #
  # @return [ Float ]
  def w_52_high
    value_for :PRICE_W52_HIGH
  end

  # The highest price within the last 52 weeks.
  #
  # @return [ Float ]
  def w_52_low
    value_for :PRICE_W52_LOW
  end

  # The date of highest price within the last 52 weeks.
  #
  # @return [ String ] ISO formated date time.
  def w_52_high_at
    @data[:DATETIME_W52_HIGH]
  end

  # The date of highest price within the last 52 weeks.
  #
  # @return [ String ] ISO formated date time.
  def w_52_low_at
    @data[:DATETIME_W52_LOW]
  end

  private

  # The performance for the given time period in %.
  #
  # @param [ Symbol ] The key where to find the value of the performance.
  #
  # @return [ Float ]
  def value_for(key)
    @data[key].round(2)
  rescue
    nil
  end
end
