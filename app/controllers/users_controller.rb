# frozen_string_literal: true

class UsersController < ApplicationController
  def profile
    current_user.build_user_department unless current_user.user_department.present?
    current_user.build_education unless current_user.education.present?
    current_user.build_dependent unless current_user.dependent.present?
  end

  def update_profile
    respond_to do |format|
      if current_user.update(user_params)
        format.html { redirect_to profile_path, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('users.dashboard_name').downcase) }
      else
        format.html { redirect_to profile_path, alert: current_user.errors.full_messages.first  }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :birthday, :role, :gender, :status, :city_id,
                                 :district_id, :address, :phone, :avatar,
                                 user_department_attributes: %i[id department_id role],
                                 education_attributes: %i[id name degree start_date end_date specialization],
                                 dependent_attributes: %i[id name address birthday relationship phone])
  end
end
