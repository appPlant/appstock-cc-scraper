require 'forwardable'
require_relative 'partial'

# A MultiPartial indicates an 1:n association between the stock instance and
# something else like events for it.
#
# @example Multiple event instances for one stock.
#   events = MultiPartial.new([{},{}], EventPartial)
#
#   events.first
#   # => EventPartial
class MultiPartial < Partial
  include Enumerable
  extend Forwardable

  # For each item a partial specified by the partial class attribute gets
  # instantiated.
  #
  # @param [ Array<Hash> ] data Array of hash items.
  #
  # @return [ MultiPartial ]
  def initialize(data, partial_class)
    @partials = (data || []).map { |item| partial_class.new(item) }

    super(data)
  end

  attr_reader :partials

  def_delegator :@partials, :each

  # If there are informations within the provided data.
  #
  # @return [ Boolean ] A true value means availability.
  def available?
    @partials && any?
  end

  # Call method equal to key and return the value for each partial.
  #
  # @param [Symbol] Method name.
  #
  # @return [ Array<Object> ]
  def [](key)
    map { |partial| partial[key] }
  end

  # Executes the given block within the scope for each partial.
  #
  # @param [ Proc ] &block Code block to execute for.
  #
  # @return [ Object ] Returned result of the executed block.
  def exec(&block)
    map { |partial| partial.exec(&block) }
  end
end
