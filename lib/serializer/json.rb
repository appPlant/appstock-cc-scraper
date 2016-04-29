require 'json'

module Serializer
  # JSON serializer for stock class.
  class JSON
    # Serializes the stock to JSON.
    #
    # @param [ Stock ] A serializable stock instance.
    #
    # @return [ String ]
    def serialize(stock)
      return '{}' unless stock.available?

      data = { source: :consorsbank, created_at: Time.now, version: 1 }

      data[:basic]    = basic_data(stock)
      data[:screener] = screener_data(stock) if stock.screener.available?
      data[:intra]    = intra_data(stock) if stock.intra.available?
      data[:risk]     = risk_data(stock) if stock.risk.available?
      data[:chance]   = chance_data(stock) if stock.chance.available?

      if stock.performance.available?
        data[:performance] = performance_data(stock)
      end

      if stock.recommendations.available?
        data[:recommendations] = recommendations_data(stock)
      end

      if stock.technical_analysis.available?
        data[:technical_analysis] = technical_analysis_data(stock)
      end

      if stock.trading_central.available?
        data[:trading_central] = trading_central_data(stock)
      end

      ::JSON.fast_generate(data, symbolize_names: false)
    end

    private

    # Extract basic stock data to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def basic_data(stock)
      { name: stock.name, wkn: stock.wkn, isin: stock.isin }
    end

    # Extract informations from thescreener to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def screener_data(stock)
      {
        per: stock.screener.per,
        risk: stock.screener.risk,
        interest: stock.screener.interest,
        updated_at: stock.screener.updated_at
      }
    end

    # Extract intra day informations to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def intra_data(stock)
      {
        price: stock.intra.price,
        currency: stock.intra.currency,
        high: stock.intra.high,
        low: stock.intra.low,
        performance: stock.intra.performance,
        volume: stock.intra.volume,
        realtime: stock.intra.realtime?,
        updated_at: stock.intra.updated_at
      }
    end

    # Extract performance informations to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def performance_data(stock)
      {
        '1w': stock.performance.of(1, :week),
        '4w': stock.performance.of(4, :weeks),
        '52w': stock.performance.of(52, :weeks),
        cy: stock.performance.of(:current, :year),
        '3y': stock.performance.of(3, :years),
        high: { price: stock.performance.high, at: stock.performance.high_at },
        low: { price: stock.performance.low, at: stock.performance.low_at }
      }
    end

    # Extract performance informations to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def recommendations_data(stock)
      {
        count: stock.recommendations.count,
        upgrades: stock.recommendations.upgrades,
        downgrades: stock.recommendations.downgrades,
        consensus: stock.recommendations.consensus,
        target_price: {
          value: stock.recommendations.target_price,
          currency: stock.recommendations.currency
        },
        expected_performance: stock.recommendations.expected_performance,
        recent: stock.recommendations.recent,
        last_quarter: stock.recommendations.last_quarter,
        updated_at: stock.recommendations.updated_at
      }
    end

    # Extract technical analyses to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def technical_analysis_data(stock)
      {
        macd: stock.technical_analysis.macd,
        momentum: {
          '20': stock.technical_analysis.momentum(20),
          '50': stock.technical_analysis.momentum(50),
          '250': stock.technical_analysis.momentum(250),
          trend: stock.technical_analysis.momentum(:trend)
        },
        moving_average: {
          '5': stock.technical_analysis.moving_average(5),
          '20': stock.technical_analysis.moving_average(20),
          '200': stock.technical_analysis.moving_average(200),
          trend: stock.technical_analysis.moving_average(:trend)
        },
        rsi: {
          '5': stock.technical_analysis.rsi(5),
          '20': stock.technical_analysis.rsi(20),
          '250': stock.technical_analysis.rsi(250),
          trend: stock.technical_analysis.rsi(:trend)
        }
      }
    end

    # Extract analyses from technicalcentral to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def trading_central_data(stock)
      {
        pivot: stock.trading_central.pivot,
        support: stock.trading_central.support_levels,
        resistance: stock.trading_central.resistance_levels,
        short_term: stock.trading_central.short_term_potential,
        medium_term: stock.trading_central.medium_term_potential,
        updated_at: stock.trading_central.updated_at
      }
    end

    # Extract risk informations to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def risk_data(stock)
      {
        bad_news_factor: stock.risk.bad_news_factor,
        bear_market_factor: stock.risk.bear_market_factor,
        beta: stock.risk.beta,
        volatility: {
          '1': stock.risk.volatility(1),
          '12': stock.risk.volatility(12)
        },
        correlation: stock.risk.correlation,
        capitalization: stock.risk.capitalization
      }
    end

    # Extract chance informations to serialize.
    #
    # @param [ Stock ]
    #
    # @return [ Hash ]
    def chance_data(stock)
      {
        dividend: stock.chance.dividend,
        earnings_revision: stock.chance.earnings_revision,
        earnings_trend: stock.chance.earnings_trend,
        long_term: stock.chance.long_term_potential,
        long_term_per: stock.chance.long_term_per,
        medium_term_technical_trend: stock.chance.medium_term_technical_trend,
        analysts: stock.chance.analysts,
        relative_performance: stock.chance.relative_performance,
        technical_reverse_price: stock.chance.technical_reverse_price,
        currency: stock.chance.currency,
        rating: stock.chance.rating
      }
    end
  end
end
