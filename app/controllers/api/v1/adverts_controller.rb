class Api::V1::AdvertsController < ApplicationController
  def index
    render json: Advert.all
  end

  def show
    render json: Advert.find(advert_params[:advert_id])
  end

  private

  def advert_params
    params.require(:advert).permit(:id)
  end
end
