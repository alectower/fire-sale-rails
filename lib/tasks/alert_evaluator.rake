desc "Fetch stock quotes and send alert emails"
task send_alerts: :environment do
  if Rails.env.production?
    today = Time.now.wday
    if today == 6 || today == 0
      puts "It's the weekend, party!"
      exit
    end
  end
  puts "running alert worker..."
  AlertWorker.perform_async
  puts "done."
end

