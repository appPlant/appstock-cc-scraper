require_relative 'partial'

# That class can be used to get informations about recommendations of a stock.
# Such informations include the target price, the upside potential or the
# recent disposition.
class RecommendationPartial < Partial
  # List of rating types
  RATING_TYPES = [:buy, :overweight, :hold, :underweight, :sell].freeze

  private_constant :RATING_TYPES

  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    super data[:RecommendationV1] || {}
  end

  # Total number of recommendations.
  #
  # @return [ Int ]
  def count
    data[:TOTAL_RECENT]
  end

  # Total number of upgraded ratings over the last 3 months.
  #
  # @return [ Int ]
  def upgrades
    data[:UP]
  end

  # Total number of downgraded ratings over the last 3 months.
  #
  # @return [ Int ]
  def downgrades
    data[:DOWN]
  end

  # Indicator of changed recommendations within the last 3 months.
  #
  # @return [ Boolean ] A true value indicates changes.
  def changes?
    count != data[:UNCHANGED]
  end

  # The consens of all ratings.
  #
  # @return [ Int ] A value between 0 (sell) and 5 (buy)
  def consensus
    data[:CONSENSUS]
  end

  # The aggregated target price of all recommondations.
  #
  # @return [ Float ]
  def target_price
    data[:TARGET_PRICE]
  end

  # The currency of the target price.
  #
  # @return [ String ] The ISO value.
  def currency
    data[:ISO_CURRENCY]
  end

  # The expected stock performance in %.
  #
  # @return [ Float ] A value between 0 and 100.
  def expected_performance
    data[:EXPECTED_PERFORMANCE_PCT].round(2)
  rescue
    nil
  end

  # The recent rating figures.
  #
  # @return [ Hash ] A hash like
  #                  { buy:A, overweight:B, hold:C, underweight:D, sell:C }
  def recent
    ratings_for :BUY_RECENT,
                :OVERWEIGHT_RECENT,
                :HOLD_RECENT,
                :UNDERWEIGHT_RECENT,
                :SELL_RECENT
  end

  # The rating figures from 3 months ago.
  #
  # @return [ Hash ] A hash like
  #                  { buy:A, overweight:B, hold:C, underweight:D, sell:C }
  def last_quarter
    ratings_for :BUY_M3,
                :OVERWEIGHT_M3,
                :HOLD_M3,
                :UNDERWEIGHT_M3,
                :SELL_M3
  end

  # The date from the last update.
  #
  # @return [ String ] A string in ISO representation.
  def updated_at
    data[:DATETIME_LAST_UPDATE]
  end

  private

  # The rating figues for the given rating types.
  # Only ratings for types included in RATING_TYPES will be returned.
  #
  # @param [ *SYMBOL ] List of keys of the interested ratings.
  #
  # @return [ Hash ] A hash like
  #                  { buy:A, overweight:B, hold:C, underweight:D, sell:C }
  def ratings_for(*keys)
    Hash[RATING_TYPES.zip(data.values_at(*keys))]
  end
end
