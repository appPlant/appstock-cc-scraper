# Informations from thescreener about the stock.
class Screener
  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    @data = data[:ScreenerV1] || {}
  end

  # The Price/Earnings Ratio used to value a company.
  #
  # @return [ Float ] A (negative) number.
  def per
    @data[:LONG_TERM_PRICE_EARING]
  end

  # The risk rating from thescreener.
  #
  # @return [ Int ] A number between -1 and 1.
  def risk
    @data[:RISK]
  end

  # The interest rating from thescreener.
  #
  # @return [ Int ] A number between 0 and ?.
  def interest
    @data[:INTEREST]
  end

  # The date from the last update.
  #
  # @return [ String ] A string in ISO representation.
  def updated_at
    @data[:DATETIME_ANALYSIS]
  end
end
