# frozen_string_literal: true

class LeaveRequestMailer < ApplicationMailer
  SUBJECT = 'Final Project - Leave Request'

  def created
    email_param = params[:email]
    @result = params

    mail(to: email_param, subject: SUBJECT)
  end

  def updated
    email_param = params[:email]
    @result = params

    mail(to: email_param, subject: SUBJECT)
  end
end
