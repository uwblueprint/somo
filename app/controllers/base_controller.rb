class BaseController < ApplicationController

  rescue_from ActiveRecord::RecordInvalid do |e|
    render json: format_error(e), status: 422
  end

private

  def format_error(e)
    {
      error_type: e.class.to_s.underscore.split('/').last,
      error: e.message,
    }
  end
end
