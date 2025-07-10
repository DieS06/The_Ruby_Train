# frozen_string_literal: true

# == Module Unit
#
# @!group 01-Models / Content / Content Units
#
# Represents a content unit module, the biggest unit after course.
# Is met to divide chapters or sections within a course.
# Inherits from {Content_Unit}.
#
# === Usage
# ModuleUnit.create(title: "Advanced Ruby Concepts", content: "Explore metaprogramming and more", created_by: user.id)
#
# @!endgroup
#

class ContentUnits::ModuleUnit < ContentUnit
end
