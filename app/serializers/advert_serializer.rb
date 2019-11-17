class AdvertSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :title, :description, :price, :created_at, :foto_url

  def foto_url
    rails_blob_url(object.car_foto)
  end
end
