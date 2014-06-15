class GroupsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_group, only: [:show, :join, :quit]

  def join
    if current_user.is_member_of?(@group)
      flash[:warning] = "You're already a member of this group."
    else
      current_user.join!(@group)
    end
    redirect_to group_path(@group)
  end

  def quit
    if current_user.is_member_of?(@group)
      current_user.quit!(@group)
    else
      flash[:warning] = "You're not a member of this group."
    end
    redirect_to group_path(@group)
  end

  def index
    @groups = Group.all
  end

  def show
    @posts = @group.posts
  end

  def new
    @group = Group.new
  end

  def edit
    @group = current_user.groups.find(params[:id])
  end

  def create
    @group = current_user.groups.new(group_params)
    if @group.save
      redirect_to group_path(@group)
    else
      render 'new'
    end
  end

  def update
    @group = current_user.groups.find(params[:id])
    if @group.update(group_params)
      redirect_to group_path(@group)
    else
      render 'edit'
    end
  end

  def destroy
    @group = current_user.groups.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

private

  def group_params
    params.require(:group).permit(:name, :description)
  end

  def find_group
    @group = Group.find(params[:id])
  end

end
