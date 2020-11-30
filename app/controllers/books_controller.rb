# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :set_book, only: %i[show edit update destroy]

  # GET /books
  def index
    @books = Book.page(params[:page])
  end

  # GET /books/1
  def show
    @comments = @book.comments.includes(:user).all
    @comment  = @book.comments.build(user_id: current_user.id) if current_user
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
    redirect_to @book, notice: t('cant_edit') unless @book.user == current_user
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    if current_user.nil?
      redirect_to @book, notice: t('need_login_for_edit')
      return
    end

    @book.user_id = current_user.id
    if @book.save
      redirect_to @book, notice: t('create_message')
    else
      render :new
    end
  end

  # PATCH/PUT /books/1
  def update
    unless @book.user == current_user
      redirect_to @book, notice: t('cant_edit')
      return
    end

    if @book.update(book_params)
      redirect_to @book, notice: t('update_message')
    else
      render :edit
    end
  end

  # DELETE /books/1
  def destroy
    unless @book.user == current_user
      redirect_to @book, notice: t('cant_destroy')
      return
    end

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
end
