class InvitationMailer < ApplicationMailer
    def custom_invite(user, inviter, message)
        @user = user
        @inviter = inviter
        @message = message.presence || t("We invite you to join our learning community!")

        mail(to: @user.email, subject: t("You have been invited to The Ruby Train platform.")) do |format|
            format.text { render layout> 'mailer' }
            format.html { render layout: 'mailer' }
        end
    end
end

# To send a mail use the next line
# InvitationMailer.custom_invite(user, inviter, message).deliver_now
# To send a mail with a custom message
# InvitationMailer.custom_invite(user, inviter, "¡Hola! Te invitamos a unirte a nuestra plataforma educativa!").deliver_now