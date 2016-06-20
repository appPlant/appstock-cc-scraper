
namespace :scrape do
  desc 'Scrape all data from consorsbank.de'
  task :stocks do
    require 'benchmark'
    require 'scraper'
    task('scraper:run').invoke(
      ENV.fetch('PER_REQUEST', 1),
      ENV.fetch('CONCURRENT_REQUESTS', 50)
    )
  end

  desc 'Scrape intraday stats from consorsbank.de'
  task :intra do
    require 'benchmark'
    require 'scraper'
    task('scraper:run').invoke(
      ENV.fetch('PER_REQUEST', 30),
      ENV.fetch('CONCURRENT_REQUESTS', 200),
      'PriceV1'
    )
  end
end

namespace :scraper do
  task :run, [:parallel, :concurrent, :fields] do |_, args|
    args.with_defaults parallel: 1,
                       concurrent: 200,
                       fields: Scraper::FIELDS.join(' ')

    parallel   = args[:parallel].to_i
    concurrent = args[:concurrent].to_i
    fields     = args[:fields].split.map(&:to_sym)

    run_scraper(parallel, concurrent, fields)
  end
end

private

# Run the scraper for the provided list of stocks.
#
# @param [ Int ] parallel Max number of stocks per request.
# @param [ Int ] concurrent Max number of concurrent requests.
# @param [ Array<Symbol> ] fields Subset of Scraper::FIELDS.
def run_scraper(parallel, concurrent, fields)
  stocks = IO.read('tmp/stocks.txt').split

  puts "Scraping #{stocks.count} stocks from consorsbank..."

  time = Benchmark.realtime do
    count = Scraper.new.run(stocks, parallel: parallel,
                                    concurrent: concurrent,
                                    fields: fields)

    puts "Scraped #{count} stocks"
  end

  puts "Time elapsed #{time.round(2)} seconds"
end
