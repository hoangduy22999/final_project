class Leader::BaseController < ApplicationController
  before_action :authenticate_leader!

  private
  
  def authenticate_leader!
    return if current_user.leader_department?

    permission_denied_response
  end

  def authenticate_department!(objects)
    current_department = current_user.department.id
    authenticate_department = 
    objects.each do |object|
    case object.class.name
      when "User", "UserDeparment"
        object.department.id.eql?(current_department)
      when "LeaveRequest"
        object.user&.department&.id&.eql?(current_department)
      else
        false
      end
    end
    return if authenticate_department
    permission_denied_response
  end
end