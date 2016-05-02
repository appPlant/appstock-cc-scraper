require_relative 'feed'

# Feed extract informations about the historical performance of a stock.
class PerformanceFeed < Feed
  source :performance

  timestamp { Time.now }

  kpi(:'1w',  from: :performance) { of(1, :week) }
  kpi(:'4w',  from: :performance) { of(4, :weeks) }
  kpi(:'52w', from: :performance) { of(52, :weeks) }
  kpi(:cy,    from: :performance) { of(:current, :year) }
  kpi(:'3y',  from: :performance) { of(3, :years) }
  kpi(:high,  from: :performance) { { price: high, at: high_at } }
  kpi(:low,   from: :performance) { { price: low, at: low_at } }
end
