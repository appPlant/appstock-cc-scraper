require 'json'
require 'feeds/fact_set_feed'
require 'feeds/intra_day_feed'
require 'feeds/performance_feed'
require 'feeds/technical_analysis_feed'
require 'feeds/the_screener_feed'
require 'feeds/trading_central_feed'
require 'feeds/events_feed'
require 'feeds/history_feed'

# JSON serializer for stock class. The serializer goes through all feeds,
# generates their content and serializes them to one JSON encoded string.
# If a feed is empty because mayve the partial isn't available then it will
# not be included.
class Serializer
  # Serializes the stock to JSON.
  #
  # @param [ Stock ] A serializable stock instance.
  #
  # @return [ String ]
  def serialize(stock)
    analyses = feeds.map { |feed| feed.generate(stock) }.compact

    return nil if analyses.empty?

    data = {
      source: :consorsbank,
      created_at: Time.now.to_i,
      version: 1,
      basic: basic_data(stock),
      feeds: analyses
    }

    JSON.fast_generate(data, symbolize_names: false)
  end

  private

  # Extract basic stock data to serialize.
  #
  # @param [ Stock ]
  #
  # @return [ Hash ]
  def basic_data(stock)
    { name: stock.name,
      wkn: stock.wkn,
      isin: stock.isin,
      country: stock.country,
      branch: stock.branch,
      sector: stock.sector,
      type: 1 }
  end

  # Feeds to use for serialization.
  #
  # @return [ Array<Feed> ]
  def feeds
    @feeds = [
      FactSetFeed,
      IntraDayFeed,
      PerformanceFeed,
      TechnicalAnalysisFeed,
      TheScreenerFeed,
      TradingCentralFeed,
      EventsFeed,
      HistoryFeed
    ].map!(&:new)
  end
end
