class Api::V1::DistrictsController < ApplicationController
  def index
    districts = District.where(city_id: params[:city_id]).ransack(params[:where]).result
    render json: DistrictSerializer.new(districts).serializable_hash, status: :ok
  end
end