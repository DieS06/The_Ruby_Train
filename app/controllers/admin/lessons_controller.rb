# frozen_string_literal: true

# == Admin::LessonsController
# @!group Controllers / Admin
# Lesson editing, admins only. (ActionText + attachments).
# @see ContentUnit::LessonUnit
# @!endgroup
#

class Admin::LessonsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource class: "ContentUnit::LessonUnit", find_by: :slug
  skip_before_action :verify_authenticity_token, only: :update
  def edit
    @lesson = ContentUnit::LessonUnit.find_by!(slug: params[:slug])
    @props = {
      lesson: {
        id: @lesson.id.to_s,
        slug: @lesson.slug,
        title: @lesson.title,
        description: @lesson.description,
        richBody: @lesson.rich_body&.to_s,
        imageUrl: @lesson.image.attached? ? url_for(@lesson.image) : nil,
        videoUrl: @lesson.video.attached? ? url_for(@lesson.video) : nil
      },
      updatePath: admin_lesson_path(@lesson.slug),
      csrfToken: form_authenticity_token,
      userRole: current_user.roles.pluck(:name)
    }
    render template: "admin/lessons/edit", layout: "application"
  end

  def update
    @lesson = ContentUnit::LessonUnit.find_by!(slug: params[:slug])
    if @lesson.update(lesson_params)
      redirect_to content_unit_path(@lesson.slug), notice: t("common.saved", default: "Saved")
    else
      redirect_back fallback_location: edit_admin_lesson_path(@lesson.slug),
                    alert: @lesson.errors.full_messages.to_sentence
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit(
      :title, :description, :position, :image, :video, :rich_body
    )
  end
end
