class BooksController < ApplicationController
  def index
    # @book = Book.find(params[:id])
    @books = Book.all.includes(:user)
    @user = current_user
    @new_book = Book.new
  end

  def show
    @book = Book.find(params[:id])
    # @user = User.find(params[:id])
    @user = @book.user
    @new_book = Book.new
  end

  def create
    @new_book = Book.new(book_params)
    @new_book.user_id = current_user.id
    if @new_book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@new_book.id)
    else
      @books = Book.all.includes(:user)
      @user = current_user
      render :index
    end
  end

  def edit
    @new_book = Book.find(params[:id])
    redirect_to action: :index unless current_user.id == @new_book.user_id
  end

  def  update
    @new_book = Book.find(params[:id])
    if @new_book.update(book_params)
      flash[:notice] = "You have updated book successfully."
      redirect_to book_path(@new_book.id)
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to '/books'
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
