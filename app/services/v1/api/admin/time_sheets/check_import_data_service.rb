class V1::Api::Admin::TimeSheets::CheckImportDataService < V1::ApplicationService
  
  def perform
    load_data
  end

  private
  
    def load_data
      @data = User.all
    end
end