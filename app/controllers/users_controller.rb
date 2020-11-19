# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  def show; end

  def followings
    @followings = @user.following_users
  end

  def followers
    @followers = @user.followers_users
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
