class V1::Api::Leaders::IndexService < V1::ApplicationService
  def perform
    load_data
  end

  private
  
    def load_data
      @data = User.includes(:department).leader_department.ransack(params[:where]).result
                  .order(order_params)
                  .paginate(page: page_params).per_page(limit_params)
    end
end