require_relative 'feed'

# Feed extract informations about the intra-day price performance of a stock.
# Such information include the current price or the traded volume.
class IntraDayFeed < Feed
  age_from :intra

  meta(:currency) { |stock| stock.intra.currency }
  meta(:exchange) { |stock| stock.intra.exchange }

  kpis_from intra: %i(price high low performance volume realtime)
end
