require "openssl"
require "base64"
require "json"
require "dotenv"

class JwtService
  def initialize(user, ip)
    @user = user
    @ip = ip
    @header = {
      alg: "SHA512",
      typ: "JWT"
    }
    @payload = {
      user_id: @user.guid,
      ip: @ip
    }
  end

  def signature
    encoded_header = Base64.urlsafe_encode64(@header.to_json, padding: false)
    encoded_payload = Base64.urlsafe_encode64(@payload.to_json, padding: false)
    secret = ENV["JWT_SECRET_KEY"]
    hmac = OpenSSL::HMAC.digest("SHA512", secret, encoded_header + "." + encoded_payload)
    Base64.urlsafe_encode64(hmac, padding: false) # для удобства использования
  end

  def jwt
    encoded_header = Base64.urlsafe_encode64(@header.to_json, padding: false)
    encoded_payload = Base64.urlsafe_encode64(@payload.to_json, padding: false)
    "#{encoded_header}.#{encoded_payload}.#{signature}"
  end
end
