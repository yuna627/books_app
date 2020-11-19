# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user

  def show
    @relationship = @user.followeds.find_by(follower_id: current_user.id)
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
