require_relative 'feed'

# Feed extract informations about the intra-day price performance of a stock.
# Such information include the current price or the traded volume.
class IntraDayFeed < Feed
  source :tradegate

  timestamp intra: :updated_at

  kpis_from intra: %i(price high low performance volume realtime)
end
