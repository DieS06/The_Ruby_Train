class ContactMailer < ApplicationMailer
  default to:   ENV.fetch("CONTACT_TO",   "support@therubytrain.com"),
          from: ENV.fetch("CONTACT_FROM", "no-reply@therubytrain.com")

  def contact_message(name:, email:, subject:, message:)
    @name    = name
    @email   = email
    @message = message

    mail(
      subject: "[Contact] #{subject.presence || 'New message'}",
      reply_to: email
    )
  end
end
