require 'sidekiq/api'
require 'platform-api'

desc "Fetch stock quotes and send alert emails"
task :alert_emailer => :environment do
  puts "running alert evaluator..."
  AlertEvaluator.run
  puts "done."
end

class AlertEvaluator
  def self.run
    emails = Alert.uniq.pluck(:email)
    emails.each do |email|
      alerts = Hash[
        Alert.where(email: email).order(:id).
          pluck(:symbol, :price)
      ]

      consumer = OAuth::Consumer.new(
        ENV['TRADEKING_CONSUMER_KEY'],
        ENV['TRADEKING_CONSUMER_SECRET'],
        { :site => 'https://api.tradeking.com' }
      )

      access_token = OAuth::AccessToken.new(
        consumer,
        ENV['TRADEKING_ACCESS_TOKEN'],
        ENV['TRADEKING_ACCESS_TOKEN_SECRET']
      )

      url = '/v1/market/ext/quotes.json?symbols='
      url << alerts.keys.join(',')
      url << "&fids=ask,bid"

      response = access_token.get url,
        {'Accept' => 'application/json'}

      companies = JSON(response.body).fetch('response').
        fetch('quotes').fetch('quote')

      companies = [companies] if companies.is_a?(Hash)

      companies.each do |company|
        alert_price = alerts[company['symbol']].to_f
        ask_price = company['ask'].to_f
        bid_price = company['bid'].to_f
        price = ask_price > 0 ? ask_price : bid_price
        if price <= alert_price
          puts 'Sending email...'
          AlertMailer.delay.send_alert email,
            company['symbol'], alert_price, price
        end
      end
    end

    scale_workers if Rails.env.production?
  rescue KeyError, StandardError => error
    ExceptionMailer.delay.mail_exception error.message,
      error.backtrace
    raise error
  end

  def self.scale_workers
    heroku = PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN'])
    heroku.formation.update ENV['APP_NAME'], 'worker', {
      "quantity" => "1",
      "size" => "1X"
    }
    ps = Sidekiq::ProcessSet.new
    loop do
      sleep(0.5)
      if ps.size == 0
        heroku.formation.update ENV['APP_NAME'],
          'worker', { "quantity" => "0" }
        break
      end
    end
  end
end
