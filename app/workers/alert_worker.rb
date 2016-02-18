class AlertWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform
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
      url << "&fids=symbol,ask,bid"

      response = access_token.get url,
        {'Accept' => 'application/json'}

      companies = JSON(response.body).fetch('response').
        fetch('quotes').fetch('quote')

      companies = [companies] if companies.is_a?(Hash)

      alert_emails = []
      companies.each do |company|
        alert_price = alerts[company['symbol']].to_f
        ask_price = company['ask'].to_f
        bid_price = company['bid'].to_f
        price = ask_price > 0 ? ask_price : bid_price
        alert_emails << {
          symbol: company['symbol'],
          alert_price: alert_price,
          price: price
        } if price <= alert_price
      end

      unless alert_emails.empty?
        puts 'sending email...'
        AlertMailer.delay.send_alert email, alert_emails
      end
    end
  rescue KeyError, StandardError => error
    ExceptionMailer.delay.mail_exception error.message,
      error.backtrace
    raise error
  end
end
