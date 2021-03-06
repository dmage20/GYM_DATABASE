class ApplicationController < ActionController::Base
  protect_from_forgery
  before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

    private

  # Overwriting the sign_out redirect path method
  # def after_sign_out_path_for(resource_or_scope)
  # #   # root_path
  # redirect_to request.referrer
  # end
end
