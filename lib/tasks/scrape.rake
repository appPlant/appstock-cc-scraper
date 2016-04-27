require 'benchmark'
require 'scraper'

namespace :scrape do
  desc 'Scrape all data from consorsbank.de'
  task :stocks do
    task('scraper:run').invoke('stocks', 10)
  end

  desc 'Scrape intraday stats from consorsbank.de'
  task :intra do
    task('scraper:run').invoke('intra', 200, 'PriceV1')
  end
end

namespace :scraper do
  task :run, [:folder, :parallel, :fields] do |_, args|
    args.with_defaults parallel: 200, fields: Scraper::FIELDS.join(' ')

    folder   = "tmp/#{args[:folder] || 'stocks'}"
    parallel = args[:parallel].to_i
    fields   = args[:fields].split.map(&:to_sym)

    rm_rf(folder)
    run_scraper(folder, parallel, fields)
  end
end

private

# Run the scraper for the provided list of stocks.
#
# @param [ String ] dir The folder where to place the stock data.
# @param [ Int ] parallel Max number of parallel requests.
# @param [ Array<Symbol> ] fields Subset of Scraper::FIELDS.
def run_scraper(dir, parallel, fields)
  stocks = IO.read('tmp/stocks.txt').split

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
