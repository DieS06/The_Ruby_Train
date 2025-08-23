class ContactMessagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :create
  skip_authorization_check
  protect_from_forgery with: :null_session, if: -> { request.format.json? }
  respond_to :json

  def create
    permitted = contact_message_params

    if Rails.env.development?
      ContactMailer.contact_message(**permitted.to_h.symbolize_keys).deliver_now
    else
      ContactMailer.contact_message(**permitted.to_h.symbolize_keys).deliver_later
    end

    render json: { message: "received", contact_message: permitted }, status: :ok
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue => e
    Rails.logger.error("[ContactMessages] #{e.class}: #{e.message}")
    render json: { error: "Message could not be sent" }, status: :internal_server_error
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end
end
