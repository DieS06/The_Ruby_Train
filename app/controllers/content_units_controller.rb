# frozen_string_literal: true

# == ContentUnitsController
#
# @!group Controllers / Content
#
# ContentUnitsController manages the content units in the system.
#
# === Endpoints
# * **GET /content_units** → `#index`
#
# @!endgroup
#

class ContentUnitsController < ApplicationController
  load_and_authorize_resource only: [ :index, :show ]

  def index
    render template: "content_unit/index", layout: "application"
  end

  def show
    @lesson = ContentUnit::LessonUnit.find_by(slug: params[:slug])
    render template: "content_unit/show", layout: "application"
  end

  private

  def lesson_params
        params.require(:lesson)
          .permit(
            :title,
            :description,
            :position,
            :parent_id,
            :rich_body_html,
            :video,
            :image
          )
  end
end
