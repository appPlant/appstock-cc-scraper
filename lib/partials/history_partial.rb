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
    items.slice!(7..-1)
  end

  attr_reader :period

  # Call method equal to key and return the value for each partial.
  #
  # @param [Symbol] Method name.
  #
  # @return [ Array<Object> ]
  def [](key)
    key == :performance ? performance : super
  end

  # The currency of the prices.
  #
  # @return [ String ] ISO currency symbol
  def currency
    data.first[:ISO_CURRENCY] if available?
  end

  # Performance of each period between each last price.
  #
  # @return [ Array<Float> ]
  def performance
    items[0..-2].zip(items[1..-1]).map! do |(cur, pre)|
      begin
        (100 - pre.last / cur.last * 100).round(2) if pre && cur.last != 0
      rescue
        nil
      end
    end
  end
end
