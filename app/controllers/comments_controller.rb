class CommentsController < ApplicationController
  before_action :set_commentable
  before_action :set_comment, only: %i[show destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to [@commentable, @comments], notice: 'Comment was successfully created.'
    else
      render :new
    end
  end

  def destroy
    @comment.destroy
    redirect_to [@commentable, @comments], notice: 'Comment was successfully destroyed.'
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
