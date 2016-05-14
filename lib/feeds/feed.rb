
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
class Feed
  # Generate the feed to the provided stock.
  #
  # @param [ Stock ] stock
  #
  # @return [ Hash ]
  def generate(stock)
    kpis = kpis(stock)

    return nil if kpis.empty?

    metas(stock).merge!(
      source: :consorsbank,
      feed: self.class.feed_name,
      kpis: kpis
    )
  end

  # The name of the feed.
  #
  # @example Get the name of FactSetFeed class.
  #   FactSetFeed.feed_name
  #   #=> :fact_set
  #
  # @return [ Symbol ]
  def self.feed_name
    @feed ||= name.scan(/(.*)Feed$/)[0][0].downcase!
  end

  # The timestamp of the feeds data.
  #
  # @example A partial holds the timestamp.
  #   timestamp screener: :updated_at
  #
  # @example Set a custom timestamp.
  #   timestamp -> { |stock| ... }
  #
  # @param [ Hash ] map A map with a single entry like partial: :method
  # @param [ Proc ] block A codeblock to execute which returns the date.
  #
  # @return [ Void ]
  def self.timestamp(map = nil, &block)
    @timestamp = map ? map.first : block if map || block
    @timestamp
  end

  # Add meta tag to the feed.
  #
  # @example Set currency for some kpis.
  #   meta(:currency) { 'EUR' }
  #
  # @param [ Symbol ] The name of the meta tag.
  # @param [ Proc] block Executable piece of code.
  #
  # @return [ Hash ]
  def self.meta(name = nil, &block)
    (@meta ||= {})[name] = block if name
    @meta
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

  # The configuration of the feed.
  #
  # @example Get config of simple and complex kpis.
  #   config
  #   #=> { simple: {..}, complex: {..}, timestamp: .. }
  #
  # @return [ Hash ]
  def self.kpis
    { simple: @kpis, complex: @nodes }
  end

  private

  # The timestamp of the feed.
  #
  # @param [ Stock ]
  #
  # @return [ Hash ]
  def timestamp(stock)
    config = self.class.timestamp

    case config
    when Array
      stock.public_send(config[0])[config[1]]
    when Proc
      config.call(stock)
    end
  end

  # The meta tags for the stock including the timestamp.
  #
  # @param [ Stock ]
  #
  # @return [ Hash ]
  def metas(stock)
    nodes  = { timestamp: timestamp(stock) }
    config = self.class.meta

    config.each_pair { |name, block| nodes[name] = block.call(stock) } if config

    nodes
  end

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
    kpis = self.class.kpis[:simple]

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
    nodes = self.class.kpis[:complex]

    return {} unless nodes

    nodes.each_with_object({}) do |(name, (scope, block)), map|
      partial   = scope ? stock.public_send(scope) : stock
      map[name] = partial.instance_exec(&block) if partial.available?
    end
  end
end
