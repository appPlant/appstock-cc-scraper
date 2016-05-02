require_relative 'feed'

# Extract informations from thescreener about the risk and chance of a stock.
# Such information include trends, ratings or relative performance stats.
class TheScreenerFeed < Feed
  source :thescreener

  timestamp risk: :updated_at

  kpis_from screener: %i(per risk interest),
            risk: %i(bad_news bear_market beta correlation),
            chance: %i(dividend earnings per trend outperformance)
  kpis_from chance: %i(reverse_price rating analysts)

  kpi(:volatility, from: :risk) do
    { '1m': volatility(1), '12m': volatility(12) }
  end
end
