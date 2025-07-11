# frozen_string_literal: true

# == GraphqlController
#
# @!group GraphQL
#
# Unique entrypoint for request with GraphQL.
#
# === Endpoint
# * **POST /graphql** → `#execute`
#
# @example Simple Request
#   POST /graphql
#   { "query": "{ me { id email } }" }
#
# @!endgroup
#

class GraphqlController < ApplicationController
  before_action :authenticate_user!, raise: true
  skip_authorization_check

  def execute
    result = TheRubyTrainSchema.execute(
      params[:query],
      variables: prepare_variables(params[:variables]),
      operation_name: params[:operationName],
      context: {
        current_user: current_user
      }
    )
    render json: result
  rescue StandardError => e
    Rails.env.development? ? handle_error_in_development(e) : render_error(e)
  end

  private

  def prepare_variables(variables_param)
    case variables_param
    when String
      variables_param.present? ? JSON.parse(variables_param) : {}
    when Hash, ActionController::Parameters
      variables_param.to_unsafe_hash
    when nil then {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param.class}"
    end
  end

  def handle_error_in_development(error)
    logger.error error.full_message
    render json: { errors: [ { message: error.message, backtrace: error.backtrace } ] }, status: :internal_server_error
  end

  def render_error(_error)
    render json: { errors: [ { message: "Internal Server Error" } ] }, status: :internal_server_error
  end
end
