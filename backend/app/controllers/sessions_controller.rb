class SessionsController < ApplicationController
  skip_before_action :authenticate!, only: %i[create]
  skip_before_action :authorize!

  # POST /api/login
  def create
    @user = User.find_by(username: params[:username])

    if @user&.authenticate(params[:password])
      token = jwt_encode_user(@user)

      render_success data: {token: token}
    else
      raise ApiError.new(I18n.t("text.账户和密码错误"), 401)
    end
  end

  # GET /api/user
  def user
    render_success data: current_user.decorate.as_fields(:session)
  end
end
