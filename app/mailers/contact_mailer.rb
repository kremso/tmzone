# encoding: utf-8

class ContactMailer < ActionMailer::Base
  default from: "kontakt@trademarkzone.sk"

  def contact(email, message)
    @email = email
    @message = message

    mail(to: 'kramar.tomas@gmail.com', subject: "Nová správa")
  end
end
