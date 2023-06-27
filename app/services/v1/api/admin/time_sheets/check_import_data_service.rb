class V1::Api::Admin::TimeSheets::CheckImportDataService < V1::ApplicationService
  
  def perform
    load_data
  end

  private
  
    def load_data
      binding.pry
      month = params[:month].split('-')
      month = Date.new(month[1].to_i, month[0].to_i, 1)
      user_ids = User.all.pluck(:id)
      time_sheets = params[:time_sheets].each do |time_sheet|
        is_valid = user_ids.include?(time_sheet[:user_id])
        {
          is_valid: is_valid
        }
      end
      @data = User.all
    end
end