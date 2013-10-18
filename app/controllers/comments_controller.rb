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

  def vote_up
    comment = Comment.find(params[:comment_id])
    if already_voted?(comment)
      redirect_to post_path(comment.post), alert: "You've already voted on comment '#{comment.title}'"
    else
      vote = comment.votes.build(type: :up)
      vote.user = current_user
      vote.save
      redirect_to post_path(comment.post), notice: "You've just voted up comment '#{comment.title}'"
    end
  end

  def vote_down
    comment = Comment.find(params[:comment_id])
    if already_voted?(comment)
      redirect_to post_path(comment.post), alert: "You've already voted on comment '#{comment.title}'"
    else
      vote = comment.votes.build(type: :down)
      vote.user = current_user
      vote.save
      comment.update_attributes(abusive: true) if comment.votes.where(type: :down).count == 3
      redirect_to post_path(comment.post), notice: "You've just voted down comment '#{comment.title}'"
    end
  end

  def mark_not_abusive
    comment = Comment.find(params[:comment_id])
    comment.abusive = false
    comment.save
    redirect_to post_path(comment.post), notice: "Comment '#{comment.title}' marked as not abusive."
  end

  private
    def already_voted? comment
      ! comment.votes.where(user: current_user).empty?
    end

end
