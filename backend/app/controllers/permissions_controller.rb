class PermissionsController < ApplicationController
  # GET /api/permissions
  def index
    @permissions = Permission.all

    render_success data: @permissions.as_json(methods: %i[controller_i18n action_i18n name name_i18n])
  end
end
