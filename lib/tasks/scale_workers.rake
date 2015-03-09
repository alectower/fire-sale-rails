require 'sidekiq/api'
require 'platform-api'

desc "Scale workers to handle background jobs"
task :scale_workers, [:seconds] => :environment do |t, args|
  puts "running alert evaluator..."
  ScaleWorkers.run(args.seconds)
  puts "done."
end

class ScaleWorkers
  def self.run(seconds)
    heroku = PlatformAPI.connect_oauth(ENV['HEROKU_OAUTH_TOKEN'])
    heroku.formation.update ENV['APP_NAME'], 'worker', {
      "quantity" => "1",
      "size" => "1X"
    }
    sleep(seconds)
    heroku.formation.update ENV['APP_NAME'],
      'worker', { "quantity" => "0" }
  end
end
