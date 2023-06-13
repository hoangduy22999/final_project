class V1::Api::RoomPickers::CreateService < V1::ApplicationService
  
  def perform
    create_object
  end

  private
  
    def create_object
      @data = current_user.room_pickers.new(object_params)

      raise Api::V1::ApplicationApi::BadRequest, @data.errors.full_messages.join(", ") unless @data.save
    end

    def object_params
      params.require(:room_picker).permit(:description, :room_id, :start_at, :end_at, :repeat_type)
    end
end