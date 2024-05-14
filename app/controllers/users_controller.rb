class UsersController < ApplicationController
  before_action :is_matching_login_user, only: [:edit, :update,]

  def index
    @users = User.all
    @user = current_user
    @new_book = Book.new
  end

  def show
    @user = User.find(params[:id])
    @currentuser = current_user
    @books = @user.books.page(params[:page])
    # @book = Book.find(params[:id])
    @new_book = Book.new
  end

  def edit
    @user = User.find(params[:id])
    redirect_to edit_user_path(other_user) if current_user.id != @user.id
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to user_path(@user.id)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image, :introduction)
  end

  def is_matching_login_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to users_path
    end
  end

end
