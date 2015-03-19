class AlertMailer < ApplicationMailer
  def send_alert(email, alerts)
    @alerts = alerts
    mail(to: email, subject: "Fire Sale Alerts!")
  end
end
