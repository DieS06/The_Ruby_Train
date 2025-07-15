# frozen_string_literal: true

# == CleanJwtDenylistJob
#
# @!group Jobs
#
# Removes expired entries from the `jwt_denylists` table.
#
# @!endgroup

class CleanJwtDenylistJob < ApplicationJob
  queue_as :maintenance

  def perform
    JwtDenylist.where("exp < ?", 7.days.ago.to_i).delete_all
  end
end
