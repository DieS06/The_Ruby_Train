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

require "ostruct"

class EvaluationService
  def self.call(user:, params:)
    evaluation = params[:id] ? Evaluation.find(params[:id]) : Evaluation.new
    return OpenStruct.new(success?: false, evaluation: nil, errors: [ "Evaluation not found" ]) unless evaluation

    unless evaluation.new_record? || evaluation.created_by == user.id
      return OpenStruct.new(success?: false, evaluation: nil, errors: [ "You are not authorized to perform this action" ])
    end

    evaluation.assign_attributes(params.except(:id))
    evaluation.created_by ||= user.id

    if evaluation.save
      OpenStruct.new(success?: true, evaluation:, errors: [])
    else
      OpenStruct.new(success?: false, evaluation: nil, errors: evaluation.errors.full_messages)
    end
  end
end
