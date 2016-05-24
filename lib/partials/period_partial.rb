require_relative 'partial'

# Informations about history performance. E.g. the high, low and volume of the
# last 12 months in weekly ranges.
class PeriodPartial < Partial
  # Opening price of the time range.
  #
  # @return [ Float ]
  def first
    data[:FIRST]
  end

  # Closing price of the time range.
  #
  # @return [ Float ]
  def last
    data[:LAST]
  end

  # Highest price of the time range.
  #
  # @return [ Float ]
  def high
    data[:HIGH]
  end

  # Lowest price of the time range.
  #
  # @return [ Float ]
  def low
    data[:LOW]
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
end