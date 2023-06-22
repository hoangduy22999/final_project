class V1::Api::Admin::Users::IndexService < V1::ApplicationService
  
  def perform
    load_data
  end

  private
  
    def load_data
      @data = User.includes(:department, district: :city).ransack(params[:where]).result
                  .order(params[:order] || {created_at: :asc})
                  .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
    end
end