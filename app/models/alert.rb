class Alert < ActiveRecord::Base
  validates_presence_of :email, :symbol, :price
  validates_uniqueness_of :symbol, scope: [:email, :price],
    message: 'Symbol and price must be unique'
end
