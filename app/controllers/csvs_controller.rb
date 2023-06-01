# frozen_string_literal: true

class CsvsController < ApplicationController
  def export
    @object = klass_name.ransack(params[:where]).result
                        .order(created_at: :desc)
                        .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
    attribute_names = params[:attribute_names][1..-2].split(",")
    @headers = attribute_names.map { |attribute_name| attribute_name.titleize }
    @method_lines = attribute_names.map { |attribute_name| attribute_name.strip }
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=#{params[:klass]}-#{Date.today}-#{current_user.full_name}.csv"
        render template: "csvs/export.csv.erb"
      end
    end
  end

  def import
  end


  private

  def klass_name
    params[:klass].constantize
  end

  def attribute_names
    params[:attribute_names].to_a.map do |attribute_name|
      [attribute_name.titleize, attribute_name.to_sym]
    end
  end
end
