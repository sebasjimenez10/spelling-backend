class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def parameter_missing(exception)
    render json: { message: exception.message }, status: :unprocessable_entity
  end
end
