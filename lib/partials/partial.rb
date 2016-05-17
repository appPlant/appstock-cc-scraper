
# Informations about a partial aspect of a stock.
class Partial
  # Initializer of the class.
  #
  # @param [ Hash ] raw The serialized raw data from BNP Paribas.
  def initialize(data)
    @data = data
  end

  attr_reader :data

  # The date from the last update.
  #
  # @return [ String ] A string in ISO representation.
  def updated_at
    Time.now
  end

  # If there are informations within the provided data.
  #
  # @return [ Boolean ] A true value means availability.
  def available?
    @data && @data.any? && updated_at
  end

  # Call method equal to key and return the value.
  #
  # @param [Symbol] Method name.
  #
  # @return [ Object ]
  def [](key)
    public_send key
  rescue
    nil
  end
end
