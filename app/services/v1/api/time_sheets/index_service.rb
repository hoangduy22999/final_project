class V1::Api::TimeSheets::IndexService < V1::ApplicationService
  
  def perform
    load_data
  end

  private
  
    def load_data
      @data = current_user.time_sheets.ransack(params[:where]).result
    end
end