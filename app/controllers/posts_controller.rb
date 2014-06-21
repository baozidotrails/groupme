class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action :find_group
  before_action :member_required, only: [:new, :create]

  def new
    @post = @group.posts.new
  end

  def edit
    @post = current_user.posts.find(params[:id])
  end

  def create
    @post = @group.posts.new(post_params)
    @post.author = current_user
    if @post.save

      # We used "counter_cache" instead of it.
      # Group.increment_counter(:posts_count, @group.id)
      redirect_to group_path(@group)
    else
      render 'new'
    end
  end

  def update
    @post = current_user.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to group_path(@group)
    else
      render 'edit'
    end
  end

  def destroy
    @post = current_user.posts.find(params[:id])
    @post.destroy

    # We used "counter_cache" instead of it.
    # Group.decrement_counter(:posts_count, @group.id)

    redirect_to group_path(@group)
  end

private

  def post_params
    params.require(:post).permit(:content)
  end

  def find_group
    @group = Group.find(params[:group_id])
  end

  def member_required
    unless current_user.is_member_of?(@group)
      flash[:warning] = "You're not a member of this group! Can't post."
      redirect_to group_path(@group)
    end
  end

end
