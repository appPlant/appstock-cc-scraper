
# Base class for stock feeds. Each feed consists of 3 parts:
#  - The name of the source
#  - Simple 1:1 mapping kpis
#  - More complex or individual kpis
#
# The Feed class provides a DSL to easily configure a Feed.
#
# class TheScreenerFeed < Feed
#   source :thescreener
#   kpis_from screener: %i(per risk interest)
#   kpi(:volatility, from: :risk) { volatility(1) }
# end
class Feed
  # Generate the feed to the provided stock.
  #
  # @param [ Stock ] stock
  #
  # @return [ Hash ]
  def generate(stock)
    kpis = kpis(stock)

    return nil if kpis.empty?

    { source: self.class.source, kpis: kpis }
  end

  class << self
    attr_reader :kpis, :nodes
  end

  # The source of the kpis.
  #
  # @example Set the source
  #   source :thescreener
  #
  # @example Get the source
  #   source
  #   => :thescreener
  #
  # @param [ Symbol ] The name of the source.
  #
  # @return [ Symbol]
  def self.source(name = nil)
    @source = name if name
    @source
  end

  # Specify the kpis to extract from the named partial.
  #
  # @example To have some kpis from stock.screener use
  #   kpis_from screener: %i(bad_news bear_market)
  #
  # @param [ Hash ] map A hash map where the keys point to stock partials
  #                     and the values are names of kpis of these partials.
  #
  # @return [ Void ]
  def self.kpis_from(map)
    @kpis ||= {}
    map.each_pair { |name, kpis| (@kpis[name] ||= []).concat kpis }
  end

  # Specify an individual more complex kpi value.
  #
  # @example To specify the volatility kpi
  #   kpi(:volatility, from: :risk) { { '1m': volatility(1) } }
  #
  # @param [ Symbol ] name The name of the kpi.
  # @param [ Symbol ] from: The optional name of the partial.
  # @param [ Proc ] Code block to execute within the scope of the partial.
  #
  # @return [ Void ]
  def self.kpi(name, from: nil, &block)
    (@nodes ||= {})[name] = [from, block]
  end

  private

  # Basic, simple and complex kpis from the stock.
  #
  # @param [ Stock ]
  #
  # @return [ Hash ]
  def kpis(stock)
    simple_kpis(stock).merge!(complex_kpis(stock))
  end

  # Extract all simple key => value kpis from the stock.
  #
  # @param [ Stock ]
  #
  # @return [ Hash ]
  def simple_kpis(stock)
    kpis = self.class.kpis

    return {} unless kpis

    kpis.each_with_object({}) do |(name, keys), map|
      partial = stock.public_send(name)
      keys.each { |key| map[key] = partial[key] } if partial.available?
    end
  end

  # Extract all more complex kpis from the stock.
  #
  # @param [ Stock ]
  #
  # @return [ Hash ]
  def complex_kpis(stock)
    nodes = self.class.nodes

    return {} unless nodes

    nodes.each_with_object({}) do |(name, (scope, block)), map|
      partial   = scope ? stock.public_send(scope) : stock
      map[name] = partial.instance_exec(&block) if partial.available?
    end
  end
end
