require_relative 'feed'

# Feed extract informations about the historical performance of a stock.
class PerformanceFeed < Feed
  age_from :performance

  meta(:currency) { |stock| stock.intra.currency }

  (1...7).each do |i|
    kpi("#{i}d") do
      if i < history.count && history.first.last && history.to_a[i].last != 0
        (100 - history.first.last / history.to_a[i].last * 100).round(2)
      end
    end
  end

  kpi(:'1w',  from: :performance) { of(1, :week) }
  kpi(:'4w',  from: :performance) { of(4, :weeks) }
  kpi(:'52w', from: :performance) { of(52, :weeks) }
  kpi(:cy,    from: :performance) { of(:current, :year) }
  kpi(:'3y',  from: :performance) { of(3, :years) }
  kpi(:high,  from: :performance) { prune price: high, age: high_at }
  kpi(:low,   from: :performance) { prune price: low, age: low_at }
end
