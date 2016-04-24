
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'rubygems'
require 'bundler/setup'

require 'rake_helpers/rspec_helper'
require 'rake_helpers/cleanup_helper'
require 'rake_helpers/tar_helper'
require 'rake_helpers/upload_helper'
require 'rake_helpers/scrape_helper'

include RSpecHelper
include CleanupHelper
include TarHelper
include UploadHelper
include ScrapeHelper

set_spec_as_default_task

namespace :scrape do
  desc 'Run Stock-Scraper to collect all data from consorsbank.de'
  task :all do
    task('scraper:run').invoke(10)
  end

  desc 'Run Stock-Scraper to collect intraday stats from consorsbank.de'
  task :intra do
    task('scraper:run').invoke(200, 'PriceV1')
  end
end

desc 'Generate a tar archive of tmp/data'
task(:tar) { create_archive }

desc 'Upload tmp/data.tar.gz to Dropbox'
task(:upload) { upload_archive }

namespace :cleanup do
  desc 'Cleanup data and archive'
  task(:all) { rm_tmp_folder }

  desc 'Remove tmp/data folder'
  task(:data)  { rm_tmp_data_folder }

  desc 'Remove tmp/data.tar.gz'
  task(:tar) { rm_archive }
end

namespace :scraper do
  task :run, [:parallel, :fields] do |_, args|
    args.with_defaults parallel: 200, fields: Scraper::FIELDS.join(' ')

    parallel = args[:parallel].to_i
    fields   = args[:fields].split.map(&:to_sym)
    dir      = "tmp/data/#{SecureRandom.uuid}"
    stocks   = IO.read('tmp/isins.txt').split

    run_scraper(stocks, dir, parallel, fields)
  end
end
