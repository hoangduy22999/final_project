# frozen_string_literal: true

module ApplicationHelper
  include UserHelper
  include TimeSheetHelper
  include LeaveRequestHelper
  include RoomHelper
  include ContractHelper
  include UserDepartmentHelper
  include SettingHelper

  def toastr_flash
    flash.each_with_object([]) do |(type, message), flash_messages|
      type = 'success' if type == 'notice'
      type = 'error' if type == 'alert'
      text = "<script>toastr.#{type}('#{message.gsub!(/'/,
                                                      '') || message}', '', { closeButton: true, progressBar: true })</script>"
      flash_messages << text.html_safe if message
    end.join("\n").html_safe
  end

  def full_name(user)
    "#{user&.first_name} #{user&.last_name}"
  end

  def full_address(user)
    "#{user&.address}, #{user&.district&.name}, #{user&.district&.city&.name}"
  end

  def page_header
    I18n.t "#{controller.controller_name}.dashboard_name"
  end

  def strftime_custom(date)
    date.strftime('%d/%m/%y')
  end
end
