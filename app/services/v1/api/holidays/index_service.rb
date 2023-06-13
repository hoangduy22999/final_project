class V1::Api::Holidays::IndexService < V1::ApplicationService
  
  def perform
    load_data
  end

  private
  
    def load_data
      @data = Holiday.ransack(params[:where]).result
    end
end