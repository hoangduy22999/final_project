class V1::Api::Districts::IndexService < V1::ApplicationService

  def perform
    load_data
  end
  
  private
    def load_data
      params_city = params[:city_id]
      district_model = params_city ? District.where(city_id: params_city) : District
      @data = district_model.ransack(params[:where]).result
                    .order(order_params)
                    .paginate(page: page_params).per_page(limit_params)
    end
end