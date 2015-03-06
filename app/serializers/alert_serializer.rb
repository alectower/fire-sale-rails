class AlertSerializer < ActiveModel::Serializer
  attributes :id, :email, :symbol, :price
end
