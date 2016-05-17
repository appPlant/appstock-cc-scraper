require_relative 'feed'

# Extract informations from consorsbank about the technical analyses like
# MACD, the rsi or momentum indicators.
class TechnicalAnalysisFeed < Feed
  timestamp technical_analysis: :updated_at

  kpis_from technical_analysis: %i(macd)

  kpi(:momentum, from: :technical_analysis) do
    {
      '20d': momentum(20),
      '50d': momentum(50),
      '250d': momentum(250),
      trend: momentum(:trend)
    }
  end

  kpi(:moving_average, from: :technical_analysis) do
    {
      '5d': moving_average(5),
      '20d': moving_average(20),
      '200d': moving_average(200),
      trend: moving_average(:trend)
    }
  end

  kpi(:rsi, from: :technical_analysis) do
    {
      '5d': rsi(5),
      '20d': rsi(20),
      '250d': rsi(250),
      trend: rsi(:trend)
    }
  end
end
