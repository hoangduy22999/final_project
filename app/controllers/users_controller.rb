# frozen_string_literal: true

class UsersController < ApplicationController
  def profile; end

  def update_profile
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to profile_path, notice: 'User was successfully updated.' }
      else
        format.html { redirect_to profile_path, alert: current_user.errors.full_messages.first  }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :birthday, :role, :gender, :status, :city_id,
                                 :district_id, :address, :phone, :avatar, user_department_attributes: %i[id department_id role])
  end
end
