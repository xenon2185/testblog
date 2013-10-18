class PostsController < ApplicationController
  before_filter :authenticate_user!
  expose_decorated(:posts)
  expose_decorated(:post)
  expose(:tag_cloud) { [] }

  def index
  end

  def new
  end

  def edit
  end

  def update
    if post.save
      render action: :index
    else
      render :new
    end
  end

  def destroy
    post.destroy if current_user.owner? post
    render action: :index
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
    @comments = Comment.desc(:created_at)
    @not_abusive_comments = Comment.not_abusive
  end

  def mark_archived
    post.archive!
    render action: :index
  end

  def create
    post.user = current_user
    if post.save
      redirect_to action: :index
    else
      render :new
    end
  end

end
