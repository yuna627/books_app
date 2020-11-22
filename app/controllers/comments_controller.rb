# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to [@commentable, @comments], notice: t('comment_was_successfully_created')
    else
      redirect_to [@commentable, @comments], notice: t('failure_to_create_a_comment')
    end
  end

  def destroy
    unless @comment.user == current_user
      redirect_to @comment, notice: t('cant_destroy')
      return
    end

    @comment.destroy
    redirect_to [@commentable, @comments], notice: t('comment_was_successfully_destroyed')
  end

  private

  def set_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
