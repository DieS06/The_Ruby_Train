# frozen_string_literal: true

# == Module
#
# @!group 01-Models / Content
#
# Represents a module inside a course, used to group segments.
#
# Inherits all behavior from ContentUnit.
#
# === Examples
#   Module.create(title: "Control Flow", parent: Course.first)
#
# @see ContentUnit
#
# @!endgroup
#

class ContentUnit::Module < ContentUnit
end
