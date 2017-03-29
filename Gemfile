source 'https://rubygems.org'

raise 'Ruby 2.2 or newer required' unless RUBY_VERSION >= '2.2.0'

gem 'typhoeus', '~> 1.0'
gem 'dropbox-sdk', '~> 1.6'
gem 'json', '~> 2.0'

gem 'whenever', '~> 0.9', require: false
gem 'rake', '~> 12', require: false

group :development, :test do
  gem 'pry-nav'
end

group :test do
  gem 'rspec', '~> 3.4'
  gem 'webmock', '~> 2.0'
  gem 'fakefs', '~> 0.8'
  gem 'timecop', '~> 0.8'
  gem 'simplecov'
  gem 'codeclimate-test-reporter'
end
