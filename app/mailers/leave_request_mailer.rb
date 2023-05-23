# frozen_string_literal: true

class LeaveRequestMailer < ApplicationMailer
  def created
    email_param = params[:email]
    @result = { email: email_param, password: params[:password], full_name: params[:full_name] }

    mail(to: email_param, subject: 'Welcom to Final Project')
  end
end
