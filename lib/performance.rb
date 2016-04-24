require 'partial'

# Informations about the performance of a stock.
class Performance < Partial
  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    super data[:PerformanceV1] || {}
  end

  # The performance of the specified time period.
  #
  # @param [ Int ] value The value of the time period.
  # @param [ Symbol] unit Supported values are :week(s) and :year(s).
  #
  # @return [ Float ]
  def of(value, unit)
    if unit == :year || unit == :years
      of_years(value)
    elsif unit == :week || unit == :weeks
      of_weeks(value)
    else
      raise "Unsupported performance unit #{unit}"
    end
  end

  # The highest price within the last 52 weeks.
  #
  # @return [ Float ]
  def high
    value_for :PRICE_W52_HIGH
  end

  # The highest price within the last 52 weeks.
  #
  # @return [ Float ]
  def low
    value_for :PRICE_W52_LOW
  end

  # The date of highest price within the last 52 weeks.
  #
  # @return [ String ] ISO formated date time.
  def high_at
    data[:DATETIME_W52_HIGH]
  end

  # The date of highest price within the last 52 weeks.
  #
  # @return [ String ] ISO formated date time.
  def low_at
    data[:DATETIME_W52_LOW]
  end

  private

  # The performance of the last weeks.
  #
  # @param [ Int ] weeks Supported values are 1, 4 and 52.
  #
  # @return [ Float ]
  def of_weeks(weeks)
    case weeks
    when 1 then value_for(:PERFORMANCE_PCT_W1)
    when 4 then value_for(:PERFORMANCE_PCT_W4)
    when 52 then value_for(:PERFORMANCE_PCT_W52)
    else raise "Unsupported performance time frame: #{weeks} weeks"
    end
  end

  # The performance of the last years.
  #
  # @param [ Int ] years Supported values are :current and 3.
  #
  # @return [ Float ]
  def of_years(years)
    case years
    when :current then value_for(:PERFORMANCE_PCT_CY)
    when 3 then value_for(:PERFORMANCE_PCT_Y3)
    else raise "Unsupported performance time frame: #{years} years"
    end
  end

  # The performance for the given time period in %.
  #
  # @param [ Symbol ] The key where to find the value of the performance.
  #
  # @return [ Float ]
  def value_for(key)
    data[key].round(2)
  rescue
    nil
  end
end
