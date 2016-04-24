require 'securerandom'
require 'typhoeus'
require 'stock'
require 'json'

class Scraper

  FIELDS = [
    :PerformanceV1,
    :PriceV1,
    :RecommendationV1,
    :ScreenerV1,
    :ScreenerAnalysisV1,
    :TechnicalAnalysisV1,
    :TradingCentralV1
  ].freeze

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
    @counter  = 0
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
  # @param [ Array<String> ] isins List of ISIN numbers.
  #
  # @return [ Int ] Total number of scraped stocks.
  def run(isins, fields: FIELDS, parallel: 200)
    return unless isins.any?

    FileUtils.mkdir_p @drop_box

    @hydra.max_concurrency = [0, parallel].max
    @counter               = 0

    isins.each_slice(500) do |subset|
      subset.each { |isin| scrape isin, fields: fields }
      @hydra.run
    end

    @counter
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
  def scrape(isin, fields: FIELDS)
    url = isin.length > 12 ? isin : url_for(isin, fields)
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
    json  = parse_response(res)
    stock = Stock.new(json)

    return unless stock.available?

    puts @counter += 1
    drop_stock(stock)
  rescue => e
    $stderr.puts "#{res.effective_url}\n#{e.message}"
  end

  # Parses the response body to ruby object.
  #
  # @param [ res ] The response with JSON encoded body.
  #
  # @return [ Object ] The parsed ruby object.
  def parse_response(res)
    return nil unless res.success?
    json = JSON.parse(res.body, symbolize_names: true)
    json = json[0] if json.is_a? Array
    json
  end

  # Save the scraped stock data in a file under @drop_box dir.
  #
  # @param [ Stock ] stock
  def drop_stock(stock)
    filepath = File.join(@drop_box, filename_for(stock))

    IO.write(filepath, stock.to_json)
  end

  # Generate a filename for a stock.
  #
  # @example Filename for Facebook stock
  #   filename_for(facebook)
  #   #=> 'facebook-01bff156-5e39-4c13-b35a-8380814ef07f.json'
  #
  # @param [ Stock ] stock The specified stock.
  #
  # @return [ String ] A filename of a JSON file.
  def filename_for(stock)
    "#{stock.isin}-#{SecureRandom.uuid}.json"
  end

  # Build url to request the content of the specified fields of the stock.
  #
  # @example URL to get the basic data only.
  #   url_for 'US30303M1027'
  #   #=> 'stocks?field=BasicV1&id=US30303M1027'
  #
  # @example URL to get the basic and performance data.
  #   url_for 'US30303M1027'
  #   #=> 'stocks?field=BasicV1&field=PerformanceV1&id=US30303M1027'
  #
  # @param [ String ] isin ISIN number of the specified stock.
  # @param [ Array<Symbol> ] Subset of Scraper::FIELDS.
  #
  # @return [ String]
  def url_for(isin, fields = [])
    url = 'https://www.consorsbank.de/ev/rest/de/marketdata/stocks?field=BasicV1'

    fields.each { |field| url << "&field=#{field}" if FIELDS.include? field }

    "#{url}&id=#{isin}"
  end
end
