class UserDecorator < ApplicationDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  FIELDS = {
    default: %i[id username name admin user_type created_at updated_at roles role_names],
    session: %i[id username name admin user_type created_at updated_at roles role_names permission_names],
  }.freeze
end
