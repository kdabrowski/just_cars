class Api::V1::AdvertsController < ApplicationController
  def index
    @adverts = Advert.where(nil)
    filtering_params(filter_params).each do |key, value|
      @adverts = @adverts.public_send(key, value) if value.present?
    end
    paginate json: @adverts
  end

  def show
    render json: Advert.find(params[:id])
  end

  def create
    advert = Advert.new(create_params)
    if advert.valid?
      advert.save
      render json: advert, status: :ok
    else
      render json: { errors: advert.errors.full_messages.to_json }.to_json, status: :unprocessable_entity
    end
  end

  private

  def filter_params
    params.permit(:after, :before, :greater, :lower)
  end

  def filtering_params(params)
    params.slice(:after, :before, :greater, :lower)
  end

  def create_params
    params.permit(:name, :title, :description, :car_foto, :price)
  end
end
