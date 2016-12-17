class BaseController < ApplicationController

  class ModelNotFoundError < StandardError
  end

  class RespondentNotFoundError < ModelNotFoundError
  end

  class SurveyExecutionStateNotFoundError < ModelNotFoundError
  end

  class LockedResourceError < StandardError
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: format_error(e), status: 404
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: format_error(e), status: 422
  end

  rescue_from ModelNotFoundError do |e|
    render json: format_error(e), status: 404
  end

  rescue_from LockedResourceError do |e|
    render json: format_error(e), status: 423
  end

private

  def format_error(e)
    {
      error_type: e.class.to_s.underscore.split('/').last,
      error: e.message,
    }
  end
end
