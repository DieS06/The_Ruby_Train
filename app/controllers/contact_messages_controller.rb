class ContactMessagesController < ApplicationController
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  def create
    cm = contact_message_params

    render json: { message: "received" }, status: :ok
  rescue => e
    Rails.logger.error(e.message)
    render json: { error: "No se pudo enviar el mensaje" }, status: :unprocessable_entity
  end

  private

  def contact_message_params
    params.require(:contact_message).permit(:name, :email, :subject, :message)
  end
end
