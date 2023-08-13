# frozen_string_literal: true

class TimeSheetMailer < ApplicationMailer
  SUBJECT = "Final Project - #{I18n.t("time_sheets.dashboard_name")}"

  def created
    email_param = params[:email]
    @result = params
    mail(to: email_param, subject: SUBJECT)
  end
end
