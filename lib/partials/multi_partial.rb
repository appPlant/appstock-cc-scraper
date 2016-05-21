require 'forwardable'

# A MultiPartial indicates an 1:n association between the stock instance and
# something else like events for it.
#
# @example Multiple event instances for one stock.
#   events = MultiPartial.new([{},{}], EventPartial)
#
#   events.first
#   # => EventPartial
class MultiPartial
  include Enumerable
  extend Forwardable

  # For each item a partial specified by the partial class attribute gets
  # instantiated.
  #
  # @param [ Array<Hash> ] data Array of hash items.
  #
  # @return [ MultiPartial ]
  def initialize(data, partial_class)
    @partial_class = partial_class
    @partials      = (data || []).map { |item| partial_class.new(item) }
  end

  attr_reader :partials, :partial_class

  def_delegator :@partials, :each

  # If there are informations within the provided data.
  #
  # @return [ Boolean ] A true value means availability.
  def available?
    @partials && any?
  end
end
