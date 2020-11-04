# frozen_string_literal: true

# class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
#   skip_before_action :verify_authenticity_token, only: :github
#   def github
#     # You need to implement the method below in your model (e.g. app/models/user.rb)
#     @user = User.from_omniauth(request.env['omniauth.auth'])
#     p @user
#     if @user.persisted?
#       set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
#       sign_in_and_redirect @user, event: :authentication
#     else
#       session['devise.github_data'] = request.env['omniauth.auth'].except(:extra)
#       redirect_to new_user_registration_url
#     end
#   end

#   def failure
#     redirect_to root_path
#   end
# end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    @user = User.find_for_github_oauth(request.env['omniauth.auth'], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
