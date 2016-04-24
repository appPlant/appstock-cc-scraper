
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rubygems'
require 'bundler/setup'

require 'securerandom'
require 'benchmark'
require 'scraper'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '--format documentation --color --require spec_helper'
  end

  task default: :spec
rescue LoadError; end # rubocop:disable Lint/HandleExceptions

namespace :scrape do
  desc 'Run Stock-Scraper to collect all data from consorsbank.de'
  task :all do
    task('scraper:run').invoke(10)
  end

  desc 'Run Stock-Scraper to collect intraday stats from consorsbank.de'
  task :intra do
    task('scraper:run').invoke(200, 'PriveV1')
  end
end

desc 'Generate a tar archive of tmp/data'
task :tar do
  `tar cfvz tmp/data.tar.gz tmp/data/`
end

namespace :clear do
  desc 'Cleanup data and archive'
  task all: [:archive, :data]

  desc 'Remove tmp/data folder'
  task :data do
    FileUtils.rm_rf 'tmp/data'
  end

  desc 'Remove tmp/data.tar.gz'
  task :archive do
    FileUtils.rm_rf 'tmp/data.tar.gz'
  end
end

namespace :scraper do
  task :run, [:parallel, :fields] do |_, args|
    args.with_defaults parallel: 200, fields: Scraper::FIELDS.join(' ')

    parallel = args[:parallel].to_i
    fields   = args[:fields].split.map(&:to_sym)

    dir     = File.join(__dir__, 'tmp/data', SecureRandom.uuid)
    stocks  = IO.read('tmp/isins.txt').split
    scraper = Scraper.new(drop_box: dir)
    count   = 0

    puts "Scraping #{stocks.count} stocks from consorsbank..."

    time = Benchmark.realtime do
      count = scraper.run(stocks, parallel: parallel, fields: fields)
    end

    puts "Scraped #{count} stocks"
    puts "Time elapsed #{time.round(2)} seconds"
  end
end
