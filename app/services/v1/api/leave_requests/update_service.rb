class V1::Api::LeaveRequests::UpdateService < V1::ApplicationService

  attr_accessor :object

  def initialize(params, opts = {})
    super
    @object = opts[:object] 
  end
  
  def perform
    update_object
  end

  private
  
    def update_object
      @data = object.update(object_params)

      raise Api::V1::ApplicationApi::BadRequest, @data.errors.full_messages.join(", ") unless @data.save
    end

    def object_params
      params.require(:leave_request).permit(:leave_type, :approve_by, :start_date, :end_date, :reason, :on_time, :reference_ids)
    end
end