class ApplicationController < ActionController::API
  include JwtConcern

  around_action :switch_locale
  before_action :authenticate!
  before_action :authorize!

  class ApiError < StandardError
    attr_reader :message, :status

    def initialize(message = "", status = 422)
      @message = message
      @status = status
      super(message)
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {message: exception.message}, status: 404
  end

  rescue_from ActiveRecord::RecordInvalid,
    ActionController::ParameterMissing,
    RailsParam::InvalidParameterError,
    I18n::InvalidLocale do |exception|
    render json: {message: exception.message}, status: 422
  end

  rescue_from ApiError do |exception|
    render json: {message: exception.message}, status: exception.status
  end

  private

  attr_reader :current_user

  # meta: {pagination: pagination_data(@projects)}
  def pagination_data(records)
    raise TypeError, "Records does not support pagniation" unless records.respond_to?(:total_count)

    {total: records.total_count, per_page: records.limit_value, page: records.current_page, total_pages: records.total_pages}
  end

  def authenticate!
    token = request.headers["Authorization"].to_s.split[1] || params[:token]
    @current_user = jwt_decode_user(token)
    return if @current_user

    raise ApiError.new(I18n.t("text.您未登录或登录已失效"), 401)
  end

  def authorize!
    return if current_user.admin?

    permission = Permission.find_by(name: "#{controller_name}##{action_name}")
    if permission && current_user.permissions.exclude?(permission)
      raise ApiError.new("#{I18n.t("text.您没有权限")}：#{permission.name_i18n}", 403)
    end
  end

  def switch_locale(&action)
    header_locale = request.headers["Accept-Language"] if ["en-US", "zh-CN"].include?(request.headers["Accept-Language"])
    locale = params["locale"] || header_locale || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def render_success(data: {}, status: 200, meta: {})
    render json: {data: data, meta: meta}, status: status
  end
end
