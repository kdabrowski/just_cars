class Api::V1::AdvertsController < ApplicationController
  def index
    render json: Advert.all
  end
end
