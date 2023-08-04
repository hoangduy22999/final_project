class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.includes(:department, district: :city).ransack(params[:where]).result
                 .order(params[:order] || {created_at: :asc})
                 .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @user = User.new
    @user.build_user_department unless @user.build_user_department.present?
    @user.build_education unless @user.build_education.present?
    @user.build_dependent unless @user.build_dependent.present?
  end
  
  def create
    password = User.random_password
    @user = User.new(user_params.merge(password: password, password_confirmation: password))
    respond_to do |format|
      if @user.save
        WelcomMailer.with(email: @user.email, password: password, full_name: @user.full_name).create.deliver_later
        format.html { redirect_to admin_users_url, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('users.dashboard_name').downcase) }
      else
        flash.now[:error] = @user.errors.full_messages.first
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @contracts = @user.contracts
    @user.build_user_department unless @user.user_department.present?
    @user.build_education unless @user.education.present?
    @user.build_dependent unless @user.dependent.present?
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to admin_user_path(id: @user.id), notice: I18n.t('active_controller.messages.updated', object_name: I18n.t('users.dashboard_name').downcase) }
        format.json { render :show, status: :ok, location: @user }
      else
        flash.now[:error] = @user.errors.full_messages.first
        format.html { render :show, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('users.dashboard_name').downcase) }
      format.json { head :no_content }
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    param_attributes = params.require(:user).permit(:email, :first_name, :last_name, :birthday, :role, :gender, :status, :city_id,
                                                    :district_id, :address, :phone, :avatar,
                                                    user_department_attributes: %i[id department_id role],
                                                    education_attributes: %i[id name degree start_date end_date specialization],
                                                    dependent_attributes: %i[id name address birthday relationship phone])
    param_attributes = param_attributes.except(:user_department_attributes) if param_attributes[:user_department_attributes] && 
                                                                               param_attributes[:user_department_attributes][:department_id].blank?
    param_attributes = param_attributes.except(:education_attributes) if param_attributes[:education_attributes] && param_attributes[:education_attributes].values.all?(&:blank?)
    param_attributes = param_attributes.except(:dependent_attributes) if param_attributes[:dependent_attributes] && param_attributes[:dependent_attributes].values.all?(&:blank?)
    param_attributes
  end
end