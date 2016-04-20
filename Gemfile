source 'https://rubygems.org'

raise 'Ruby 2.2 or newer required' unless RUBY_VERSION >= '2.2.0'

gem 'typhoeus', '~> 1.0'
gem 'oj', '~> 2'

group :development, :test do
  gem 'pry-nav'
end

group :test do
  gem 'rake'
  gem 'rspec', '~> 3.4'
  gem 'webmock', '~> 1.24'
  gem 'fakefs', '~> 0.8'
  gem 'simplecov'
  gem 'codeclimate-test-reporter'
end