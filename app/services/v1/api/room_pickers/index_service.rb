class V1::Api::RoomPickers::IndexService < V1::ApplicationService

  def perform
    load_data
  end

  private
    def load_data
      @data = RoomPicker.includes(:user, :room).ransack(params[:where]).result.map do |room_picker|
        {
          id: room_picker.id,
          room_id: room_picker.room_id,
          repeat: room_picker.repeat,
          start_at: room_picker.start_at,
          end_at: room_picker.end_at,
          room_color: room_picker.room.color,
          room_text_color: room_picker.room.text_color,
          description: room_picker.description,
          user_id: room_picker.user_id,
          user_name: room_picker.user.full_name,
          repeat_type: room_picker.repeat_type,
          editable: room_picker.user_id.eql?(current_user.id)
        }
      end
    end
end