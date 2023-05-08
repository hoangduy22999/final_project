class V1::ApplicationService
  attr_reader :params, :page_params, :limit_params, :current_user, :order_params
  attr_accessor :data

  def initialize(params, opts = {})
    @params       = params
    @page_params  = params[:page] || 1
    @limit_params = params[:limit] || 20
    @order_params = "#{params[:order_column] || 'created_at'} #{params[:order_type] || 'desc'}"
    @current_user = opts[:current_user]
  end

  def perform; end
end