class ContentUnits::LessonUnit < ContentUnit
  has_one_attached :video
  has_many_attached :images
  has_rich_text :content
end
