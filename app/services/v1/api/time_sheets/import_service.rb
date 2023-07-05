class V1::TimeSheets::ImportService < V1::ApplicationService

  def initialize
    super
    @type = params[:import_type]
  end

  def perform
    case type
    when 'check_invalid_data'
    end
  end

  private

  def import_multi
  end
end