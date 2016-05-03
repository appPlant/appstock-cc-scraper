require_relative 'feed'

# Extract informations from tradingcentral about the technical analyses like
# MACD, support and resistance levels, rsi or momentum values..
class TradingCentralFeed < Feed
  source :tradingcentral

  timestamp trading_central: :updated_at

  meta(:currency) { |stock| stock.intra.currency }

  kpis_from trading_central: %i(pivot supports resistors short_term medium_term)
  kpis_from technical_analysis: %i(macd)

  kpi(:momentum, from: :technical_analysis) do
    {
      '20': momentum(20),
      '50': momentum(50),
      '250': momentum(250),
      trend: momentum(:trend)
    }
  end

  kpi(:moving_average, from: :technical_analysis) do
    {
      '5': moving_average(5),
      '20': moving_average(20),
      '200': moving_average(200),
      trend: moving_average(:trend)
    }
  end

  kpi(:rsi, from: :technical_analysis) do
    {
      '5': rsi(5),
      '20': rsi(20),
      '250': rsi(250),
      trend: rsi(:trend)
    }
  end
end
