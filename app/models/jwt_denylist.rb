# frozen_string_literal: true

# == JwtDenylist
#
# @!group 01-Models / Auth
#
# Invalid JWT tokens list.
#
# === Attributes
# @!attribute [r] jti
#   @return [String] Unique identification of reoked token.
# @!attribute [r] exp
#   @return [Integer] UNIX expiration token.
#
# @example Create a denylist entry
#   JwtDenylist.create!(jti: decoded[:jti], exp: decoded[:exp])
#
# @!endgroup
#

class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist
  self.table_name = "jwt_denylists"
end
