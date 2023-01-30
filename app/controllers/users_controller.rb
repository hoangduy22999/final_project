# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.includes(:department, district: :city).ransack(params[:where]).result
                 .order(created_at: :desc)
                 .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE)
  end

  def show; end

  def edit; end

  def new
    @user = User.new
  end

  def create
    password = User.random_password
    binding.pry
    @user = User.new(user_params.merge(password: password, password_confirmation: password))
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url(@user), notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        flash.now[:error] = @user.errors.full_messages.first
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_url(@user), notice: 'User was successfully updated.' }
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
      format.html { redirect_to user_index_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def profile
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :birthday, :role, :gender, :status, :city_id,
                                 :district_id, :address, :phone, :avatar, user_department_attributes: [:id, :department_id, :role])
  end
end
