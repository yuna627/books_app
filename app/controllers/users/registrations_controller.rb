# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash = {})
    hash[:uid] = User.create_unique_string
    super
  end

  def update
    super
    resource.avatar.attach(account_update_params[:avatar]) if account_update_params[:avatar].present?
  end

  protected

  def update_resource(resource, params)
    if resource.provider == 'github'
      # Allows user to update registration information without password.
      resource.update_without_password(params.except('current_password'))
    else
      # Require current password if user who isn't signin from github.
      super
    end
  end
end
