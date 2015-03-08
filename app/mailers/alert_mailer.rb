class AlertMailer < ApplicationMailer
  def send_alert(email, symbol, alert_price, price)
    @symbol = symbol
    @alert_price = alert_price
    @current_price = price
    mail(to: email, subject: "Fire Sale Alert for #{symbol}!")
  end
end
