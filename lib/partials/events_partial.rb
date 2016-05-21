require_relative 'multi_partial'
require_relative 'event_partial'

# Enumerable like partial that holds all events for a stock.
class EventsPartial < MultiPartial
  # Initialize an event partial for each item within the specified data array.
  #
  # @param [ Array<Hash> ] data The serialized raw data from BNP Paribas.
  #
  # @return [ EventPartial ]
  def initialize(data)
    super (data[:EventsV1] || {})[:ITEMS], EventPartial
  end
end
