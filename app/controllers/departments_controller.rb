# frozen_string_literal: true

class DepartmentsController < ApplicationController
  def index
    @departments = Department.includes(:users, :manager, user_departments: :user).all.paginate(page: params[:page])
  end
end
