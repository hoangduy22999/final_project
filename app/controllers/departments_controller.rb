class DepartmentsController < ApplicationController

  def index
    @departments = Department.includes(:users, :manager).all.paginate(page: params[:page])
  end
end