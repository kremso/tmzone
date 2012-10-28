# encoding: utf-8
class WatchingMailer < ActionMailer::Base
  default from: "watching@trademarkzone.sk"

  def watching_request(registration_number, application_number, name, email)
    @registration_number = registration_number
    @application_number = application_number
    @name = name
    @email = email

    mail(to: 'kramar.tomas@gmail.com', subject: "Požiadavka na sledovanie od #{name}")
  end
end
