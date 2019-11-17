class Api::V1::AdvertsController < ApplicationController
  def index
    @adverts = Advert.where(nil)
    filtering_params(filter_params).each do |key, value|
      @adverts = @adverts.public_send(key, value) if value.present?
    end
    render json: @adverts
  end

  def show
    render json: Advert.find(params[:id])
  end

  private

  def filter_params
    params.permit(:after, :before, :greater, :lower)
  end

  def filtering_params(params)
    params.slice(:after, :before, :greater, :lower)
  end
end
