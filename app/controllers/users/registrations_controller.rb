# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def build_resource(hash = {})
    hash[:uid] = User.create_unique_string
    super
  end

  protected

  def update_resource(resource, params)
    if resource.provider == 'github'
      resource.update_without_password(params.except('current_password'))
    else
      super
    end
  end
end
