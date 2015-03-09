class FireSaleController < ApplicationController
  def index
    render text: redis.get(version)
  end

  private

  def version
    params[:version] ||= redis.get("fire-sale:current")
  end

  def redis
    @redis ||= -> do
      url = ENV['REDIS_URL'] || 'redis://localhost:6379'
      Redis.new url: url
    end.call
  end
end
