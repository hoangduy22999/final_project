# time_sheet_csvs_controller.rb

class CsvsController < ApplicationController
	def index
		@users = User.all

		respond_to do |format|
			format.html
			format.csv { send_data @users.to_csv, filename: "users-#{Date.today}.csv" }
		end
	end
end