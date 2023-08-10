class V1::Api::RoomPickers::RepeatService < V1::ApplicationService

  def perform
    load_data
  end

  private
    def load_data
      start_date = params[:where][:start_at_gteq].to_date
      end_date = params[:where][:end_at_lteq].to_date
      time_range = (start_date..end_date)
      one_time_pickers = RoomPicker.repeat_type_one_time.where(start_at: time_range)
      @data = (RoomPicker.includes(:user, :room).repeat_pickers + one_time_pickers).map do |room_picker|
        time_range = room_picker.repeat ? time_range : time_range.select { |date| room_picker.start_at.beginning_of_day <= date }

        selected_date = case room_picker.repeat_type
        when 'one_time'
          time_range.select {|date| room_picker.start_at.all_day.cover?(date)}
        when 'daily'
          time_range
        when 'weekly'
          time_range.select {|date| room_picker.start_at.wday == date.wday}
        when 'monthly'
          time_range.select {|date| room_picker.start_at.day == date.day}
        when 'yearly'
          time_range.select {|date| room_picker.start_at.day == date.day && room_picker.start_at.month == date.month}
        else
          {}
        end

        time_range = (start_date..end_date)
        next if selected_date.blank?

        selected_date.map do |date|
          {
            id: room_picker.id,
            room_id: room_picker.room_id,
            repeat: room_picker.repeat,
            repeat_type: room_picker.repeat_type,
            start_at: room_picker.start_at.change(year: date.year, month: date.month, day: date.day),
            end_at: room_picker.end_at.change(year: date.year, month: date.month, day: date.day),
            room_color: room_picker.room.color,
            room_text_color: room_picker.room.text_color,
            description: room_picker.description,
            user_id: room_picker.user_id,
            user_name: room_picker.user.full_name,
            editable: room_picker.user_id.eql?(current_user.id)
          }
        end
      end.flatten.compact
    end
end