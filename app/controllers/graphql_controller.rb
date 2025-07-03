# frozen_string_literal: true

class GraphqlController < ApplicationController

  before_action :authenticate_user!, raise: true
  skip_authorization_check
  
  def execute
    # BORRAR LUEGO
    Rails.logger.debug "DEBUG (GraphQL): Request received." 

     if current_user
      Rails.logger.debug "DEBUG (GraphQL): Current user is present: ID #{current_user.id}, Email #{current_user.email}"
    else
      Rails.logger.debug "DEBUG (GraphQL): Current user is NIL. Authentication failed at controller level."
    end
    # BORRAR LUEGO

    variables = prepare_variables(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      current_user: current_user,
    }
    # BORRAR LUEGO
    Rails.logger.debug "DEBUG (GraphQL): Executing schema with query: #{query.first(50)}..."
    # BORRAR LUEGO

    result = TheRubyTrainSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    # BORRAR LUEGO
    Rails.logger.debug "DEBUG (GraphQL): Schema execution complete. Result data: #{result['data'] ? 'present' : 'nil'}, errors: #{result['errors'] ? 'present' : 'nil'}"
    # BORRAR LUEGO

    render json: result
  rescue StandardError => e
    raise e unless Rails.env.development?
    handle_error_in_development(e)
  end

  private

  # Handle variables in form data, JSON body, or a blank value
  def prepare_variables(variables_param)
    case variables_param
    when String
      if variables_param.present?
        JSON.parse(variables_param) || {}
      else
        {}
      end
    when Hash
      variables_param
    when ActionController::Parameters
      variables_param.to_unsafe_hash # GraphQL-Ruby will validate name and type of incoming variables.
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{variables_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { errors: [{ message: e.message, backtrace: e.backtrace }], data: {} }, status: 500
  end
end
