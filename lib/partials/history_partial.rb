require_relative 'multi_partial'
require_relative 'period_partial'

# Enumerable like partial that holds all weekly performance data for a stock.
class HistoryPartial < MultiPartial
  # Initialize an history partial for each item within the specified data array.
  #
  # @param [ Array<Hash> ] data The serialized raw data from BNP Paribas.
  # @param [ String ] url The URL where the data comes from.
  #
  # @return [ EventPartial ]
  def initialize(data, url)
    @period = url.to_s.scan(/resolution=(.{2})/).flatten.first

    super (data[:HistoryV1] || {})[:ITEMS], PeriodPartial
  end

  attr_reader :period

  # The currency of the prices.
  #
  # @return [ String ] ISO currency symbol
  def currency
    data.first[:ISO_CURRENCY] if available?
  end
end
