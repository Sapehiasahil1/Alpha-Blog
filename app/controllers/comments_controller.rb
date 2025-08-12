class CommentsController < ApplicationController
  before_action :authenticate_request!
  before_action :set_article

  def create
    @comment = @article.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash.now[:notice] = "Comment was successfully created."
    else
      flash[:alert] = "Comment could not be saved."
    end
    redirect_to article_path(@article)
  end

  def destroy
    @comment = @article.comments.find(params[:id])
    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      flash.now[:notice] = "Comment was successfully deleted."
    else
      flash[:alert] = "You can only delete your own comments."
    end
    redirect_to article_path(@article)
  end

  private

  def set_article
    @article = Article.find(params[:article_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
