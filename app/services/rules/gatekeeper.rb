# frozen_string_literal: true

module Rules
  module Gatekeeper
    module_function

    def allowed?(user, evaluation)
      settings = evaluation.evaluation_setting&.config || {}
      return true if settings["advance_only"]

      unit = evaluation.content_unit
      return true if unit.nil?
      case evaluation.type
      when "Quiz"
        any_lesson_progress?(user, unit)
      when "Exam"
        segments_half_done?(user, unit)
      else
        true
      end
    end

    def any_lesson_progress?(user, segment)
      lesson_ids = ContentUnit.where(parent_id: segment.id, type: "Lesson").pluck(:id)
      return false if lesson_ids.empty?
      Progress.where(user_id: user.id, content_unit_id: lesson_ids).where("progress_percentage > 0").exists?
    end

    def segments_half_done?(user, mod)
      seg_ids = ContentUnit.where(parent_id: mod.id, type: "Segment").pluck(:id)
      return false if seg_ids.empty?
      done = Progress.where(user_id: user.id, content_unit_id: seg_ids).where("progress_percentage >= 50").count
      done == seg_ids.size
    end
  end
end
