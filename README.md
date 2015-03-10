# Rails App

Prereqs: postgresql, redis, foreman

```
cd rails
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
cp .env.sample .env
redis-server &
foreman start
```
