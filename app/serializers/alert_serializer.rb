class AlertSerializer < ActiveModel::Serializer
  attributes :email, :symbol, :price
end
