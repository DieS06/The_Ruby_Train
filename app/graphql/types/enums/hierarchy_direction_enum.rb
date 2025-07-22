# frozen_string_literal: true

# == HierarchyDirectionEnum
#
# @!group 02-GraphQL / Enums
#
# Enum to specify the traversal direction for content unit hierarchy.
#
# === Values
# * `ASC`: Traverse hierarchy upwards (to parent units).
# * `DESC`: Traverse hierarchy downwards (to children units).
# * `CHAIN`: Traverse upwards forming a single chain through parents.
#
# @!endgroup
#
module Types
  module Enums
    class HierarchyDirectionEnum < Types::BaseEnum
      description "Direction of hierarchy traversal: ASC (upward) or DESC (downward)"

      value "ASC", "Traverse up to parent units", value: "ASC"
      value "DESC", "Traverse down to child units", value: "DESC"
      value "CHAIN", "Upward traversal forming a single chain through parents."
    end
  end
end
