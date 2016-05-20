require_relative 'feed'

# Feed extract informations about recommendations of a stock. Such informations
# include the target price, the upside potential or the recent disposition.
class FactSetFeed < Feed
  age_from :recommendations

  meta(:currency) { |stock| stock.recommendations.currency }

  kpis_from recommendations: %i(upgrades downgrades consensus target_price)
  kpis_from recommendations: %i(count expected_performance recent last_quarter)
end
