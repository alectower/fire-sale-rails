class FireSaleController < ApplicationController
  def index
    render text: redis.get('#{version}:index.html')
  end

  private

  def version
    params[:version] ||= 'release'
  end

  def redis
    @redis ||= if Rails.env.development?
      Redis.new
    else
      Redis.new url: ENV['REDISTOGO_URL']
    end
  end
end
