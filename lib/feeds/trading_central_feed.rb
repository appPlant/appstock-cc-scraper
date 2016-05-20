require_relative 'feed'

# Extract informations from tradingcentral about the technical analyses like
# the support and resistance levels.
class TradingCentralFeed < Feed
  age_from :trading_central

  meta :currency, &:currency

  kpis_from trading_central: %i(pivot supports resistors short_term medium_term)
end
