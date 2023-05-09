class V1::Api::LeaveRequests::UpdateService < V1::ApplicationService
  
  def perform
    create_object
  end

  private
  
    def create_object
      @data = current_user.leave_requests.new(object_params)

      raise Api::V1::ApplicationApi::BadRequest, @data.errors.full_messages.join(", ") unless @data.save
    end

    def object_params
      params.require(:leave_request).permit(:leave_type, :approve_by, :start_date, :end_date, :reason, :on_time, :reference_ids)
    end
end