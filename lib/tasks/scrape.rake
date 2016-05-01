require 'benchmark'
require 'scraper'

namespace :scrape do
  desc 'Scrape all data from consorsbank.de'
  task :stocks do
    task('scraper:run').invoke ENV.fetch('STOCKS_CONCURRENT', 35)
  end

  desc 'Scrape intraday stats from consorsbank.de'
  task :intra do
    task('scraper:run').invoke ENV.fetch('INTRA_CONCURRENT', 200), 'PriceV1'
  end
end

namespace :scraper do
  task :run, [:parallel, :fields] do |_, args|
    args.with_defaults parallel: 200, fields: Scraper::FIELDS.join(' ')

    parallel = args[:parallel].to_i
    fields   = args[:fields].split.map(&:to_sym)

    run_scraper(parallel, fields)
  end
end

private

# Run the scraper for the provided list of stocks.
#
# @param [ Int ] parallel Max number of parallel requests.
# @param [ Array<Symbol> ] fields Subset of Scraper::FIELDS.
def run_scraper(parallel, fields)
  stocks = IO.read('tmp/stocks.txt').split

  puts "Scraping #{stocks.count} stocks from consorsbank..."

  time = Benchmark.realtime do
    count = Scraper.new.run(stocks, parallel: parallel, fields: fields)
    puts "Scraped #{count} stocks"
  end

  puts "Time elapsed #{time.round(2)} seconds"
rescue StandardError => e
  $stderr.puts "#{e.class}: #{e.message}"
end
