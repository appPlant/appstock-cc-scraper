require 'time'

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
  def age_in_days
    diff_in_days Time.now
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

  # Calculate diff in days between today and the specified date.
  #
  # @param [Numeric|String|Date] obj The date to diff agains today.
  #
  # @return [ Int ]
  def diff_in_days(obj)
    return nil unless available? && obj

    date =  case obj
            when Numeric then Time.at(obj)
            when String then Time.parse(obj)
            else obj
            end.to_date

    (Date.today - date).to_i
  end
end
