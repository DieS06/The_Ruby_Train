# frozen_string_literal: true

# == BadgeAwardedNotifier
#
# Notifier that delivers a notification when a user earns a badge.
#
# === Params
# @param badge [Badge] the badge that was awarded
#
# === Delivery methods
# * :database — stores the notification in the database
#
# === Example
#   BadgeAwardedNotifier.with(badge: badge).deliver_later(user)
#
# To deliver this notification:
#
# BadgeAwardedNotifier.with(record: @post, message: "New post").deliver(User.all)

class BadgeAwardedNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
  # required_param :message

  deliver_by :database

  param :badge

  def message
    "You’ve earned the badge: #{params[:badge].name}"
  end

  def url
    "/dashboard/badges/#{params[:badge].id}" # Ajusta esta URL a tu frontend
  end
end
