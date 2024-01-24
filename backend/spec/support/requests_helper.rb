module RequestsHelper
  include JwtConcern

  def auth_headers(user)
    return if user.nil?

    token = jwt_encode_user(user)

    {Authorization: "Bearer #{token}"}
  end

  def response_data
    response.parsed_body.dig("data")
  end

  def response_meta
    response.parsed_body.dig("meta")
  end

  def response_message
    response.parsed_body.dig("message")
  end

  def expect_status(status)
    expect(response).to have_http_status(status)
  end

  def expect_success
    aggregate_failures do
      expect_status 200
      expect(response_message).to eq(nil)
    end
  end

  def expect_failed(message)
    aggregate_failures do
      expect_status 422
      expect(response_message).to match(message)
    end
  end
end

RSpec.configure do |config|
  config.include RequestsHelper, type: :request
end
