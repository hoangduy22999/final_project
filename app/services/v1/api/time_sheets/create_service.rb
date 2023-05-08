class V1::Api::TimeSheets::IndexService < V1::ApplicationService
  
  def perform
    create_object
  end

  private
  
    def create_object
      @data = current_user.time_sheets.create(object_params)
    end

    def object_params
      params.require(:time_sheet).permit(:keeping_type)
    end
end