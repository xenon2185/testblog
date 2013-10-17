class CommentsController < ApplicationController

  def create
    post = Post.find(params[:post_id])
    comment = post.comments.build(params[:comment])
    comment.user = current_user
    comment.save
    redirect_to post, notice: "Comment created!"
  end

  def edit
    @post = Post.find(params[:post_id])
    @comment = Comment.find(params[:id])
  end

  def update
    comment = Comment.find(params[:id])
    if comment.user == current_user && comment.update_attributes(params[:comment])
      redirect_to comment.post, notice: "Successfully updated comment."
    else
      render 'edit'
    end
  end 

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      notice = "Successfully deleted comment."
    else
      notice = "Comment cannot be deleted."
    end
    redirect_to comment.post, notice: notice
  end

end
