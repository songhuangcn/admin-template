class ApplicationDecorator < Draper::Decorator
  # Define methods for all decorated objects.
  # Helpers are accessed through `helpers` (aka `h`). For example:
  #
  #   def percent_amount
  #     h.number_to_percentage object.amount, precision: 2
  #   end

  FIELDS = {
    default: %i[id created_at updated_at]
  }.freeze

  def as_fields(type = :default)
    fields = self.class::FIELDS[type]
    raise ArgumentError, "Undefined or invalid type `#{type.inspect}`" unless fields.is_a?(Array)

    as_json(only: [], methods: fields)
  end

  private

  def as_storage_attachment(attachment)
    return if attachment.blank?

    {
      blob_id: attachment.blob_id,
      blob_url: Rails.application.routes.url_helpers.rails_blob_url(attachment)
    }
  end
end
