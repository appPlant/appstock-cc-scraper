require_relative 'partial'

# Informations about the price of a stock.
class IntraDayPartial < Partial
  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    super data[:PriceV1] || {}
  end

  # The price of the stock.
  #
  # @return [ Float ]
  def price
    data[:PRICE]
  end

  # The highes traded price.
  #
  # @return [ Float ]
  def high
    data[:HIGH]
  end

  # The lowest traded price.
  #
  # @return [ Float ]
  def low
    data[:LOW]
  end

  # The currency of the price.
  #
  # @return [ String ] ISO currency symbol
  def currency
    data[:ISO_CURRENCY]
  end

  # If its a realtime price.
  #
  # @return [ Boolean ] A true value means its realtime.
  def realtime?
    data[:IS_REALTIME]
  end

  # The intraday performance in percent.
  #
  # @return [ Float ]
  def performance
    data[:PERFORMANCE_PCT].round(2)
  rescue
    nil
  end

  # The traded volume
  #
  # @return [ Int ]
  def volume
    data[:TOTAL_VOLUME]
  end

  # The code of the stock exchange
  #
  # @return [ String ]
  def exchange
    data[:CODE_EXCHANGE]
  end

  # When the price was updated.
  #
  # @return [ String ] ISO datetime value.
  def updated_at
    data[:DATETIME_PRICE]
  end
end
