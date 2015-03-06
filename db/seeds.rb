# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Alert.delete_all
Alert.create(email: 'alectower@gmail.com', symbol: 'AAPL', price: '100')
Alert.create(email: 'alectower@gmail.com', symbol: 'GE', price: '20')
Alert.create(email: 'alectower@gmail.com', symbol: 'T', price: '30')
