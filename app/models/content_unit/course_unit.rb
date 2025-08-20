# frozen_string_literal: true

# == CourseUnit
#
# @!group 01-Models / Content
#
# Represents the top-level content unit in a course hierarchy.
#
# Inherits all behavior from ContentUnit.
#
# === Examples
#   Course.create(title: "Ruby Basics", ...)
#
# @see ContentUnit
#
# @!endgroup
#

class ContentUnit::CourseUnit < ContentUnit
  include CustomStiName
end
