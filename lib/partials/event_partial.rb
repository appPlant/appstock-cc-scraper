require_relative 'partial'

# Informations about a event like the Annual General Meeting.
class EventPartial < Partial
  # The type of the event like 'AGM' for Annual General Meeting or 'RESULTS'.
  #
  # @return [ String ]
  def type
    data[:EVENT_TYPE]
  end

  # Descriptive name of the event like 'Ordentliche Hauptversammlung'.
  #
  # @return [ String ]
  def name
    data[:NAME_EVENT]
  end

  # Number of days when the event will occur.
  #
  # @return [ Int ]
  def occurs_in
    -diff_in_days(data[:DATETIME_EVENT])
  rescue
    nil
  end
end
