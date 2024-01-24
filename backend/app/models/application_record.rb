class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  scope :latest, -> { order(id: :desc) }

  def storage_url(storage)
    Rails.application.routes.url_helpers.rails_blob_url(storage) if storage.present?
  end

  def attachment_url(storage)
    return if storage.blank?

    Rails.application.routes.url_helpers.url_for(controller: "uploads",
      action: "show",
      id: storage.id)
  end

  def to_cwyy(date)
    return if date.blank?

    # ISO 8601 标准的周日历格式
    date.to_date.strftime("%V%g")
  end
end
