class FireSaleController < ApplicationController
  def index
    render text: redis.get('fire-sale:#{version}')
  end

  private

  def version
    params[:version] ||= 'current'
  end

  def redis
    @redis ||= if Rails.env.development?
      Redis.new
    else
      Redis.new url: ENV['REDISTOGO_URL']
    end
  end
end
