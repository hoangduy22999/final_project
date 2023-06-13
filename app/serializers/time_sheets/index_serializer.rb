class TimeSheets::IndexSerializer < ActiveModel::Serializer
  attributes :id

  attribute(:title) { object.keeping_type.humanize + ' - ' + object.keeping_time.strftime("%H:%M%p") }
  attribute(:start) { object.keeping_time.strftime("%FT%T") }
  attribute(:color) { keeping_color }
  attribute(:textColor) { keeping_color }


  private

  def keeping_color
    object.keeping_type_check_in? ? 'green' : 'red'
  end
end