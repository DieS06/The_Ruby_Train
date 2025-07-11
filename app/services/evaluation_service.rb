# frozen_string_literal: true

# == EvaluationService
#
# @!group 02-Services / Evaluation
#
# Handles the creation and update of an Evaluation.
#
# === Usage
#   EvaluationService.call(user: current_user, params: {...})
#
# === Parameters
# @param user [User] The current user performing the action
# @param params [Hash] The permitted attributes for Evaluation
#
# === Behavior
# * If `params[:id]` is present, it updates an existing Evaluation.
# * If not, it creates a new one.
# * Automatically sets `created_by` on create.
#
# === Raises
# * CanCan::AccessDenied if user is not authorized
# * ActiveRecord::RecordInvalid if validation fails
#
# @return [Evaluation] The created or updated evaluation
#
# @!endgroup

class EvaluationService
  def self.call(user:, params:)
    evaluation = aprams[:id] ? Evaluation.find(params[:id]) : Evaluation.new
    raise CanCan::AccessDenied unless evaluation.new_record? || evaluation.create_by == user.id

    evaluation.assign_attributes(params.except(:id))
    evaluation.created_by ||= user.id

    evaluation.save!
    evaluation
  end
end
