# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_github_oauth(request.env['omniauth.auth'])

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
  end
end
