class Alert < ActiveRecord::Base
  validates_presence_of :email, :symbol, :price
  validates_uniqueness_of :email, scope: [:symbol, :price]
end
