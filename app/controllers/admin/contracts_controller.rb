class Admin::ContractsController < Admin::BaseController
  before_action :set_contract, only: %i(show update destroy)
  before_action :set_user

  def index
    @contracts = @user.contracts
  end

  def new
    @contract = @user.contracts.build
  end
  
  def show; end

  def create
    @contract = @user.contracts.build(contract_params)
    if @contract.save
      redirect_to admin_users_path(id: @user.id, tab_pane: "ex-with-icons-tab-2"), notice: I18n.t('active_controller.messages.created',
                                                                                   object_name: I18n.t('contracts.dashboard_name').downcase)
    else
      flash.now[:error] = @department.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
    if @contract.destroy
      return_hash =  notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('departments.dashboard_name').downcase)
    else
      return_hash = {alert: @contract.errors.full_messages.first}
    end
    redirect_to admin_users_path(id: @user.id, tab_pane: "ex-with-icons-tab-2"), return_hash
  end

  private

  def set_contract
    @contract = Contract.find(params[:id])

    permission_denied_response unless can? :read, @contract
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def contract_params
    params.require(:contract).permit(:user_department_id, :base_salary, :contract_type, :description, :end_date, :payment_form, :start_date)
  end
end