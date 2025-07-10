# frozen_string_literal: true

# == Lesson Unit
#
# @!group 01-Models / Content / Content Units
#
# Represents a content unit lesson, the smaller unit of content.
# Inherits from {Content_Unit}.
#
# === Usage
# LessonUnit.create(title: "Introduction to Ruby", content: "Learn the basics of Ruby programming", created_by: user.id)
#
# @!endgroup
#

class ContentUnits::LessonUnit < ContentUnit
  has_one_attached :video
  has_many_attached :images
  has_rich_text :content
end

# == Schema Information
# Table name: content_units
#  id           :bigint           not null, primary key
#  title        :string           not null
#  content      :text             not null
#  created_by   :bigint           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  type         :string           not null
#
# Table name: active_storage_attachments
#  id           :bigint           not null, primary key
#  name         :string           not null
#  record_type  :string           not null
#  record_id    :bigint           not null
#  blob_id      :bigint           not null
#  created_at   :datetime         not null
#  video        :string           not null
#  images       :string           not null
#  rich_text    :text             not null
#
