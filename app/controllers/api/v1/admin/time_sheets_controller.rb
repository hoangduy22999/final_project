class Api::V1::Admin::TimeSheetsController < Api::V1::Admin::AdminsController

  def check_import_data
    service = V1::Api::Admin::TimeSheets::CheckImportDataService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_success(data, Admin::Users::IndexSerializer)
  end
end