require 'sidekiq/api'
require 'platform-api'

desc "Scale workers to handle background jobs"
task :scale_workers, [:workers, :seconds] => :environment do |t, args|
  if args.seconds.nil?
    abort "Must provide seconds e.g. scale_workers[num_workers, seconds]"
  end
  ScaleWorkers.run(args.workers, args.seconds.to_f)
  puts "done."
end

class ScaleWorkers
  def self.run(workers, seconds)
    if Rails.env.production?
      heroku = PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN'])
      puts "scaling workers up..."
      heroku.formation.update ENV['APP_NAME'], 'worker', {
        "quantity" => workers,
        "size" => "1X"
      }
      puts "performing jobs..."
      sleep(seconds)
      puts "scaling workers down..."
      heroku.formation.update ENV['APP_NAME'],
        'worker', { "quantity" => "0" }
    else
      puts "sleep for #{seconds} seconds"
    end
  end
end
