# frozen_string_literal: true

# == User
#
# @!group 01-Models / Users
#
# Authenticable entity with Devise, JWT, roles and states.
#
# === Main Attributes
# @!attribute [rw] first_name
#   @return [String]
# @!attribute [rw] last_name
#   @return [String]
# @!attribute [rw] email
#   @return [String]
# @!attribute [rw] state
#   @return [String] Enum: pending, inactive, active, suspended.
#
# === Callbacks
# * `after_confirmation` → activa el estado.
# * `after_invitation_accepted` → activa el estado.
#
# @example Invite Example
#   current_user.invite_another_user(
#     email: "new@user.com",
#     first_name: "New",
#     last_name:  "User"
#   )
#
# @!endgroup
#
class User < ApplicationRecord
  before_destroy :prevent_super_admin_deletion

  enum :state, {
    pending:   "pending",
    inactive:  "inactive",
    active:    "active",
    suspended: "suspended"
  }, suffix: true

  rolify
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable,
         :jwt_authenticatable, :omniauthable,
         jwt_revocation_strategy: JwtDenylist,
         omniauth_providers: [ :google_oauth2 ]
  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile

  validates :first_name, presence: true, length: { maximum: 70 }
  validates :last_name, presence: true, length: { maximum: 70 }
  validates :country, presence: true, length: { maximum: 100 }
  validates :phone_number, presence: true, uniqueness: true,
            format: { with: /\A\+\d{1,3}\d{9,15}\z/,
            message: "Must be a valid phone number" }
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 12 }, if: :password_required?,
            format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{12,}\z/,
            message: "Must include at least one lowercase letter, one uppercase letter, and one digiter, and be at least 8 characters long" }
  validate :must_have_email_or_phone
  validates :state, allow_blank: false, presence: true
  after_create :assign_default_role

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def has_role_for?(role_name, resource)
    has_role?(role_name, resource)
  end

  def activate_state
    active_state! if pending_state?
  end

  def active_for_authentication?
    super && active_state?
  end

  def inactive_message
    return :not_active unless active_state?
    super
  end

  def suspend_user
    suspended_state! unless suspended_state?
  end

  def after_confirmation
     active_state! unless active_state?
  end

  def after_invitation_accepted
    active_state!
  end

  def invite_another_user(email:, first_name:, last_name:, message: nil)
    UserInvitationService.call(
      inviter: self,
      email: email,
      first_name: first_name,
      last_name: last_name,
      message: message || "You have been invited to join The Ruby Train platform. Please accept the invitation to get started."
    )
  end

  def self.accept_invitation!(attrs, invited_by:, invitation_token:)
    user = super
    user.activate_state
    user
  end

  def build_profile!
    return if self.profile.present?

    create_profile!(
      bio: "This is a default bio. Please update your profile.",
      linkedin_url: "",
      github_url: "",
      website_url: "",
      location: "Add your location here",
      company_name: "If it applies, add your company name here",
      job_title: "Add your job title here"
    )
  end

  def self.from_google_omniauth(auth)
    where(email: auth.info.email).first_or_create do |user|
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  private

  def must_have_email_or_phone
    if email.present? || phone_number.present?
      errors.add(:base, "Email or phone number are required.")
    end
  end

  def password_required?
    confirmed? && (new_record? || password.present? || password_confirmation.present?)
  end

  def assign_default_role
    self.add_role(:student) if roles.blank?
  end

  def prevent_super_admin_deletion
    if has_role?(:super_admin)
      errors.add(:base, "Cannot delete a super admin.")
      throw :abort
    end
  end
end
