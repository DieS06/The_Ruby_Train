# frozen_string_literal: true

# == JwtDenylist
#
# @!group 01-Models / Auth
#
# Invalid JWT tokens list.
#
# === Attributes
# @!attribute [r] jti
#   @return [String] Identificador único del token revocado.
# @!attribute [r] exp
#   @return [Integer] Expiración UNIX del token.
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
