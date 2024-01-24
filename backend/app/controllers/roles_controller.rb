class RolesController < ApplicationController
  before_action :set_role, only: %i[show update destroy]

  # GET /api/roles
  def index
    param! :page, Integer
    param! :per_page, Integer

    @roles = Role.includes(:roles_permissions).page(params[:page]).per(params[:per_page]).latest

    render_success data: @roles.as_json(methods: %i[permission_count permission_names]),
      meta: {pagination: pagination_data(@roles)}
  end

  # POST /api/roles
  def create
    ActiveRecord::Base.transaction do
      @role = Role.create!(role_params)

      @role.roles_permissions.each(&:destroy!)
      roles_permission_params.each do |permission_name|
        @role.roles_permissions.create!(permission_name: permission_name)
      end
    end

    render_success data: @role.as_json(methods: %i[permission_names])
  end

  # PATCH/PUT /api/roles/1
  def update
    ActiveRecord::Base.transaction do
      @role.update!(role_update_params)

      @role.roles_permissions.each(&:destroy!)
      roles_permission_params.each do |permission_name|
        @role.roles_permissions.create!(permission_name: permission_name)
      end
    end

    render_success data: @role.as_json(methods: %i[permission_names])
  end

  # DELETE /api/roles/1
  def destroy
    @role.destroy!

    render_success
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def role_params
    param! :name, String, blank: false

    params.permit(:name)
  end

  def role_update_params
    param! :name, String

    params.permit(:name)
  end

  def roles_permission_params
    param! :permission_names, Array, default: []

    params[:permission_names].tap do |arg|
      raise ApiError, I18n.t("text.参数 `permissions` 格式不正确") unless arg.all? { |item| item.is_a?(String) }
    end
  end
end
