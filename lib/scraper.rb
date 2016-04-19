require 'typhoeus'
require 'stock'
require 'oj'

class Scraper
  # Intialize the scraper.
  #
  # @example With a custom drop box location.
  #   Scraper.new drop_box: '/Users/katzer/tmp'
  #
  # @param [ String ] drop_box: Optional information where to place the result.
  #
  # @return [ Fetcher ] A new scraper instance.
  def initialize(drop_box:)
    @drop_box = drop_box
    @hydra    = Typhoeus::Hydra.new
  end

  attr_reader :drop_box

  # Run the hydra with the given ISIN numbers to scrape their data.
  #
  # @example Scrape Facebook Inc.
  #   run('US30303M1027')
  #
  # @example Scrape Facebook and Amazon
  #   run('US30303M1027', 'US0231351067')
  #
  # @param [ Array<String> ] List of ISIN numbers.
  #
  # @return [ Void ]
  def run(*isins)
    return unless isins.any?

    FileUtils.mkdir_p @drop_box

    isins.each { |isin| scrape isin }

    @hydra.run
  end

  private

  # Scrape the content of the stock specified by his ISIN number.
  # The method workd async as the `on_complete` callback of the response
  # object delegates to the fetchers `on_complete` method.
  #
  # @example Scrape Facebook Inc.
  #   scrape('US30303M1027')
  #
  # @param [ String ] isin The International Securities Identification Number.
  #
  # @return [ Void ]
  def scrape(isin)
    url = "https://www.consorsbank.de/ev/rest/de/marketdata/stocks?field=AlternativesV1&field=BasicV1&field=CompanyProfileV1&field=EventsV1&field=ExchangesV1&field=FundamentalV1&field=HistoryV1&field=PerformanceV1&field=PriceV1&field=RecommendationV1&field=ScreenerV1&id=#{isin}" # rubocop:disable Metrics/LineLength
    req = Typhoeus::Request.new(url)

    req.on_complete(&method(:on_complete))

    @hydra.queue req
  end

  # Callback of the `scrape` method once the request is complete.
  # The containing stocks will be saved to into a file. If the list is
  # paginated then the linked pages will be added to the queue.
  #
  # @param [ Typhoeus::Response ] res The response of the HTTP request.
  #
  # @return [ Void ]
  def on_complete(res)
    json  = Oj.load(res.body, symbol_keys: true)[0]
    stock = Stock.new(json)

    puts stock.inspect
  end
end
