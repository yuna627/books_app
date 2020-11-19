# frozen_string_literal: true

class RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:follow_id])
    redirect_to root_path
  end

  def destroy
    Relationship.find(params[:id]).destroy
    redirect_to root_path
  end
end
