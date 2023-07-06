class Admin::ContractsController < Admin::BaseController

  before_action :set_contract, only: %i(show update destroy)

  def index
    @contracts = Contract.ransack(params[:where]).result
                          .order(status: :desc, created_at: :desc)
                          .paginate(page: params[:page] || 1)
                          .per_page(params[:per_page] || 15)
  end
  
  def show; end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])

    permission_denied_request unless can? :read, @contract
  end

  def contract_params
    params.require(:contract).permit(:user_department_id, :base_salary, :contract_type, :description, :end_date, :payment_form, :start_date)
  end
end