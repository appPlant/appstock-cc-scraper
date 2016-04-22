# Informations from thescreener about the outlook of the stock.
class Chance
  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    @base = data[:ScreenerAnalysisV1] || {}
    @data = @base[:CHANCE] || {}
  end

  # The dividend per stake.
  #
  # @return [ Float ]
  def dividend
    value_of :DIVIDEND
  end

  # Difference of earning expectations in the last 7 weeks in %.
  #
  # @return [ Float ]
  def earnings_revision
    value_of :EARINGS_REVISION
  end

  # The trend of the earning revisions in the last 7 weeks in %.
  #
  # @return [ Int ] A positive number indicates a positive market mood.
  def earnings_trend
    value_of :EARINGS_REVISION_TREND
  end

  # The growth potential till the end of next year.
  #
  # @return [ Float ]
  def long_term_potential
    value_of :LONGTERM_GROWTH
  end

  # The earnings grows potential till the end of next year.
  #
  # @return [ Float ]
  def long_term_per
    value_of :LONG_TERM_PRICE_EARING
  end

  # The midterm technical 40-days trend.
  #
  # @return [ Int ] A value between -1 and 1.
  def medium_term_technical_trend
    value_of :MEDIUM_TERM_TECHNICAL_TREND
  end

  # The total number of analysts in the last 7 weeks.
  #
  # @return [ Int ]
  def analysts
    value_of :NUMBER_OF_ANALYSTS
  end

  # The relative performance compared to its benchmark in last 4 weeks in %.
  #
  # @return [ Float ]
  def relative_performance
    value_of :RELATIVE_PERFORMANCE_W4
  end

  # The technical reverse point.
  #
  # @return [ Float ]
  def technical_reverse_price
    value_of :TECHNICAL_REVERSE
  end

  # The rating of the current stock valuation.
  #
  # @return [ Int ]
  def rating
    value_of :VALUATION_RATING
  end

  # The price currency.
  #
  # @return [ String ] ISO currency symbol
  def currency
    @base[:ISO_CURRENCY]
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
