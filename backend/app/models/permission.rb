class Permission
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serializers::JSON

  NOT_PERMISSION_CONTROLLERS = [
    /^rails\//,
    /^sessions$/,
    /^permissions$/
  ].freeze

  attribute :controller, :string
  attribute :action, :string

  validates :controller, format: {with: /\A[a-z_]+\z/}
  validates :action, format: {with: /\A[a-z_]+\z/}

  class << self
    def all
      @all ||= begin
        routes = Rails.application.routes.routes
          .map { |route| route.defaults.slice(:controller, :action) }
          .reject { |route| NOT_PERMISSION_CONTROLLERS.any? { |regex| route[:controller].nil? || regex.match?(route[:controller]) } }
          .uniq

        routes.map do |route|
          new(
            controller: route[:controller],
            action: route[:action]
          )
        end
      end
    end

    def find_by(name:)
      all.find { |permission| permission.name == name }
    end

    def where(name:)
      all.select { |permission| name.include?(permission.name) }
    end
  end

  def name
    "#{controller}##{action}"
  end

  def name_i18n
    "#{controller_i18n}#{action_i18n}"
  end

  def controller_i18n
    I18n.t("controller.#{controller}")
  end

  def action_i18n
    I18n.t("action.#{action}")
  end

  def inspect
    "#<#{self.class} #{attributes}>"
  end
end
