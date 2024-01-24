class UsersController < ApplicationController
  before_action :set_user, only: %i[update destroy]

  # GET /api/users
  def index
    param! :page, Integer
    param! :per_page, Integer

    @users = User.includes(:roles).page(params[:page]).per(params[:per_page]).latest

    render_success data: @users.decorate.map(&:as_fields), meta: {pagination: pagination_data(@users)}
  end

  # POST /api/users
  def create
    @user = User.create!(user_params)

    render_success data: @user.decorate.as_fields
  end

  # PATCH/PUT /api/users/1
  def update
    @user.update!(user_update_params)

    render_success data: @user.decorate.as_fields
  end

  # DELETE /api/users/1
  def destroy
    @user.destroy!

    render_success
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
    raise ApiError.new(I18n.t("text.无法操作管理员账户"), 403) if @user.admin?
  end

  # Only allow a list of trusted parameters through.
  def user_params
    param! :username, String, blank: false
    param! :password, String, blank: false
    param! :name, String, blank: false
    param! :role_ids, Array

    params.permit(:username, :password, :name, role_ids: [])
  end

  def user_update_params
    param! :username, String
    param! :password, String
    param! :name, String
    param! :role_ids, Array

    params.permit(:username, :password, :name, role_ids: [])
  end
end
