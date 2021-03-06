# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  def show
    if current_user
      @relationship = @user.followings.find_by(follower_id: current_user.id)
    end
  end

  def followings
    @followings = @user.following_users
  end

  def followers
    @followers = @user.follower_users
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
