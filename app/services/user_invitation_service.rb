class UserInvitationService
  def self.call(inviter:, email:, first_name:, last_name:, message:)
    raise CanCan::AccessDenied unless Ability.new(inviter).can?(:invite, User)

    invited = User.invite!(email: email, first_name: first_name, last_name: last_name)
    invited.create_profile unless invited.profile
    InvitationMailer.custom_invite(invited, inviter, message).deliver_later


    Rails.logger.info "#{self.full_name} invited #{invited.email}"
    invited
  end
end
