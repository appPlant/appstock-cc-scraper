
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
    @data && @data.any?
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

  protected

  # Remove all nil values from object and return nil if empty.
  #
  # @example
  #   prune [1, nil]
  #   # => [1, nil]
  #
  # @example
  #   prune [nil]
  #   # => nil
  #
  # @example
  #   prune { k: 1 }
  #   # => { k: 1 }
  #
  # @example
  #   prune { k: nil }
  #   # => nil
  #
  # @param [ Array ] ary
  #
  # @return [ Array ]
  def prune(obj)
    return nil unless available?

    case obj
    when Array
      obj.clear if obj.all?(&:nil?)
    when Hash
      obj.delete_if { |_, v| v.nil? }
    end

    obj if obj.any?
  end
end
