# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]
  before_action :check_resource_owner, only: %i[update destroy edit]
  before_action :authenticate_user!, only:%i[new create]

  # GET /books
  def index
    @books = Book.page(params[:page])
  end

  # GET /books/1
  def show
    @comments = @book.comments.includes(:user).all
    if current_user
      @comment  = @book.comments.build(user_id: current_user.id)
    end
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit; end

  # POST /books
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to @book, notice: t('create_message')
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  def update
    if @book.update(book_params)
      redirect_to @book, notice: t('update_message')
    else
      render :edit
    end
  end

  # DELETE /books/1
  def destroy
    @book.destroy
    redirect_to books_url, notice: t('delete_message')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :memo, :author, :picture)
  end

  def check_resource_owner
    redirect_to @book, notice: t('cant_edit_or_destroy') unless @book.user == current_user
  end
end
