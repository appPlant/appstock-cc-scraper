
# That module can be used to get access to common stock properties found inside
# the BasicV1 key map. This includes properties like ISIN or the name.
# The module expects a `data` method which returns a symbolized hash of the raw
# API response.
module Basic
  # The name of the stock.
  #
  # @return [ String ]
  def name
    data[:BasicV1][:NAME_SECURITY]
  rescue
    nil
  end

  # The Wertpapierkennnummer is a German securities identification code.
  #
  # @return [ String ] A code of six digits or capital letters.
  def wkn
    data[:BasicV1][:ID][:WKN]
  rescue
    nil
  end

  # The International Securities Identification Number (ISIN).
  #
  # @return [ String ] A 12-character alpha-numerical code.
  def isin
    data[:BasicV1][:ID][:ISIN]
  rescue
    nil
  end

  # The ticker symbol on Tradegate.
  #
  # @return [ String ] Often a 3-character alpha-numerical code.
  def symbol
    data[:BasicV1][:ID][:SYMBOL]
  rescue
    nil
  end

  # The associated branch.
  #
  # @return [ String ]
  def branch
    data[:BasicV1][:NAME_BRANCH]
  rescue
    nil
  end

  # The sector within the branch.
  #
  # @return [ String ]
  def sector
    data[:BasicV1][:NAME_SECTOR]
  rescue
    nil
  end
end
