# frozen_string_literal: true

module Api
  module V1
    class DistrictsController < ApplicationController
      def index
        districts = District.where(city_id: params[:city_id]).ransack(params[:where]).result.order(name: :asc)
        render json: DistrictSerializer.new(districts).serializable_hash, status: :ok
      end
    end
  end
end
