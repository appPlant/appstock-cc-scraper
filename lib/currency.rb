require 'yaml'
require 'singleton'

# Singleton class that knows each country's currency.
#
# @example Currency of Germany.
#   Currency['DE']
#   #=> 'EUR'
class Currency
  include Singleton

  # Loads the currencies.yaml into memory.
  def initialize
    @currencies = YAML.load_file('lib/data/currencies.yaml')
  end

  # The country's ISO currency code.
  #
  # @example Currency of Germany.
  #   currency.of('DE')
  #   #=> 'EUR'
  #
  # @param [ String ] country ISO country code.
  #
  # @return [ String ]
  def of(country)
    @currencies[country]
  end

  # The country's ISO currency code.
  #
  # @example Currency of USA.
  #   currency.of('US')
  #   #=> 'USD'
  #
  # @param [ String ] country ISO country code.
  #
  # @return [ String ]
  def self.[](country)
    instance.of(country)
  end
end
