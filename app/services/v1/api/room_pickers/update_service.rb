class V1::Api::RoomPickers::UpdateService < V1::ApplicationService

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
      @data = object
      raise Api::V1::ApplicationApi::BadRequest, @data.errors.full_messages.join(", ") unless @data.update(object_params)
    end

    def object_params
      params.require(:room_picker).permit(:description, :room_id, :start_at, :end_at, :repeat_type)
    end
end