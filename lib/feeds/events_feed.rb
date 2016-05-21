require_relative 'multi_feed'

# Feed extract informations of events of a stock. Such informations
# include the type, descriptive name and when it will occur.
class EventsFeed < MultiFeed
  age_from :events

  kpis_from events: %i(type occurs_in)
end
