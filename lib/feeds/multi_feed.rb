require_relative 'feed'

# Base class for stock feeds. Each feed consists of 3 parts:
#  - Meta tags
#  - Simple 1:1 mapping kpis
#  - More complex or individual kpis
#
# The Feed class provides a DSL to easily configure a Feed.
#
# class TheScreenerFeed < Feed
#   kpis_from screener: %i(per risk interest)
#   kpi(:volatility, from: :risk) { volatility(1) }
# end
class MultiFeed < Feed
  # Generate the feed to the provided stock.
  #
  # @param [ Stock ] stock
  #
  # @return [ Hash ]
  def generate(stock)
    feed = super

    return nil unless feed

    meta = feed.delete(:meta)
    size = feed.values[0].size

    items = (0...size).map do |i|
      feed.each_with_object({}) { |(k, v), item| item[k] = v[i] }
    end

    { items: items, meta: meta }
  end
end
