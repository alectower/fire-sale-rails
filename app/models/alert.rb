class Alert < ActiveRecord::Base
  validates_presence_of :email, :symbol, :price
end
