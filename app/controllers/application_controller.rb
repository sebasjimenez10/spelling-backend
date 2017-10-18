class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :parameter_missing
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def parameter_missing(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end

  def not_found(exception)
    render json: { message: exception.message }, status: :not_found
  end
end
