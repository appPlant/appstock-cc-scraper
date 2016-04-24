require 'benchmark'
require 'scraper'

# Methods to be used in the Rakefile related to scraping the data.
module ScrapeHelper
  # Run the scraper for the provided list of stocks.
  #
  # @param [ Array<String> ] isins List of ISIN numbers.
  # @param [ String ] dir The folder where to place the stock data.
  # @param [ Array<String> ] isins List of ISIN numbers.
  # @param [ Int ] parallel Max number of parallel requests.
  # @param [ Array<Symbol> ] fields Subset of Scraper::FIELDS.
  def run_scraper(stocks, dir, parallel, fields)
    puts "Scraping #{stocks.count} stocks from consorsbank..."

    time = Benchmark.realtime do
      scraper = Scraper.new(drop_box: dir)
      count   = scraper.run(stocks, parallel: parallel, fields: fields)
      puts "Scraped #{count} stocks"
    end

    puts "Placed files under #{dir}"
    puts "Time elapsed #{time.round(2)} seconds"
  rescue StandardError => e
    $stderr.puts "#{e.class}: #{e.message}"
  end
end
