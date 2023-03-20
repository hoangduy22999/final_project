# frozen_string_literal: true

class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  def index
    @departments = Department.includes(:users, :manager, user_departments: :user).all.paginate(page: params[:page])
  end

  def new
    @department = Department.new
    2.times { @department.user_departments.build }
  end

  def show
  end

  def update

  end

  def create
    binding.pry
  end

  def destroy
    @department.destroy

    respond_to do |format|
      format.html { redirect_to departments_path, notice: "Department was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_department
    @department = Department.find_by(id: params[:id])
  end

  def department_params
    @params.require(:department).permit(:name, user_departments: [:user_id, :role])
  end
end
