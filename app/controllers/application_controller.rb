# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def index
    redirect_to books_url
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit :sign_up, keys: %i[name email password password_confirmation]
    devise_parameter_sanitizer.permit :account_update, keys: %i[name email password password_confirmation zipcode address introduction avatar]
    devise_parameter_sanitizer.permit :sign_in, keys: %i[email password]
  end
end
