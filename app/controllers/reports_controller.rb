# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]
  before_action :check_resource_owner, only: %i[update destroy edit]
  before_action :authenticate_user!, only:%i[new create]

  # GET /reports
  # GET /reports.json
  def index
    @reports = Report.page(params[:page])
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
    @comments = @report.comments.includes(:user).all
    @comment  = @report.comments.build(user_id: current_user.id) if current_user
  end

  # GET /reports/new
  def new
    @report = Report.new
  end

  # GET /reports/1/edit
  def edit; end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id unless current_user.nil?
    if @report.save
      redirect_to @report, notice: t('create_message')
    else
      render :new
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    if @report.update(report_params)
      redirect_to @report, notice: t('update_message')
    else
      render :edit
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    redirect_to reports_url, notice: t('delete_message')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def report_params
    params.require(:report).permit(:title, :memo)
  end

  def check_resource_owner
    redirect_to @report, notice: t('cant_edit_or_destroy') unless @report.user == current_user
  end
end
