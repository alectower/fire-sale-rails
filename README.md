# Fire Sale

Back-end for Fire Sale

Fire Sale is a stock alert app that sends the user an alert
email once a stock has dropped below a given price.

A background job is run twice daily (9:30am EST,
4:00pm EST) to check stock prices and send emails.

Stock symbols and alert prices can be entered through the
[Ember front-end app](https://github.com/uniosx/fire-sale-ember "Fire Sale Ember App").

# Rails App Setup

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
