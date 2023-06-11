class V1::Api::RoomPickers::IndexService < V1::ApplicationService

  def perform
    load_data
  end

  private
    def load_data
      @data = current_user.leave_requests.ransack(params[:where]).result
                                         .order(order_params)
                                         .paginate(page: page_params).per_page(limit_params)
    end
end