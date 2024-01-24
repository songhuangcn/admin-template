module JwtConcern
  extend ActiveSupport::Concern

  def jwt_encode_user(user, exp = 7.days.from_now)
    payload = {
      exp: exp.to_i,
      user_id: user.id
    }

    JWT.encode(payload, Rails.application.secret_key_base)
  end

  def jwt_decode_user(token)
    data = JWT.decode(token, Rails.application.secret_key_base)
    user_id = data.first["user_id"]
    User.find_by(id: user_id)
  rescue JWT::DecodeError => e
    Rails.logger.error e
    nil
  end
end
