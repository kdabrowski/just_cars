class AdvertSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :car_foto, :created_at
end
