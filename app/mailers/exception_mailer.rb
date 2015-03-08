class ExceptionMailer < ApplicationMailer
  def mail_exception(message, backtrace)
    @message = message
    @backtrace = backtrace
    mail(to: 'alectower@gmail.com', subject: 'Fire Sale Exception')
  end
end
