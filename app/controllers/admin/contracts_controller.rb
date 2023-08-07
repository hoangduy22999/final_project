class Admin::ContractsController < Admin::BaseController
  before_action :set_contract, only: %i(show update destroy inactive_status)
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
      redirect_to admin_user_path(id: @user.id, tab_pane: "ex-with-icons-tab-2"), notice: I18n.t('active_controller.messages.created',
                                                                                   object_name: I18n.t('contracts.dashboard_name').downcase)
    else
      flash.now[:error] = @contract.errors.full_messages.first
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @contract.user.eql?(@user) && @contract.update(contract_params)
      return_hash =  {notice: I18n.t('active_controller.messages.updated', object_name: I18n.t('contracts.dashboard_name').downcase)}
      redirect_to admin_user_path(id: @user.id, tab_pane: "ex-with-icons-tab-2"), return_hash
    else
      redirect_to admin_user_contract_path(id: @contract.id, user_id: @user.id), alert: @contract.errors.full_messages.first
    end
  end

  def inactive_status
    if @contract.status_active?
      @contract.status_inactive!
      return_hash = {notice: I18n.t('active_controller.messages.contract.inactived')}
    else
      return_hash = {alert: I18n.t('active_controller.messages.contract.inactive_already')}
    end
    redirect_to admin_user_path(id: @user.id, tab_pane: "ex-with-icons-tab-2"), return_hash
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
    params.require(:contract).permit(:base_salary, :contract_type, :description, :end_date, :start_date, :status)
  end

  def set_one_active
    Contract.set_one_active(@contract)
  end
end