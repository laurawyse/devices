class ApplicationController < ActionController::API
  def ping
    render json: { status: 'ok' }
  end

  rescue_from Cache::NotFound do
    render json: { error_message: 'Device Not Found' }, status: :not_found
  end
end
