require_relative 'multi_feed'

# Feed extract informations of historical performances of a stock.
# Such informations include the low, high or traded volume within a period.
class HistoryFeed < MultiFeed
  age_from :history

  meta(:currency) { |stock| stock.history.currency }
  meta(:period) { |stock| stock.history.period }

  kpis_from history: %i(first last high low volume performance volatility age)
end
