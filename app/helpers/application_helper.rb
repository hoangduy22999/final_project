# frozen_string_literal: true

module ApplicationHelper
  include UserHelper
  include TimeSheetHelper

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
    action = controller.action_name
    "#{action.eql?('index') ? 'List' : action} #{controller.controller_name}".titleize
  end

  def strftime_custom(date)
    date.strftime('%d/%m/%y')
  end
end
