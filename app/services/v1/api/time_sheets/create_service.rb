class V1::Api::TimeSheets::CreateService < V1::ApplicationService
  
  def perform
    create_object
  end

  private
  
    def create_object
      @data = current_user.time_sheets.new(object_params.merge(keeping_time: Time.now))

      raise Api::V1::ApplicationApi::BadRequest, @data.errors.full_messages.join(", ") unless @data.save
    end

    def object_params
      params.require(:time_sheet).permit(:keeping_type)
    end
end