class PasswordsController < ApplicationController
	def change_password
	end

	def reset_password
		data_params = password_params
		if current_user.valid_password?(password_params["current_password"]) && current_user.update(password_params.tap { |p| p.delete("current_password") })
      redirect_to change_password_path, notice: "Password has been update successfully"
    else
      redirect_to change_password_path, alert: "Password wrong or not confirmed. Please try again"
    end
	end

	private

	def password_params
		params.require(:user).permit(:current_password, :password, :password_confirmation)
	end
end