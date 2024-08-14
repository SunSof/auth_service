class RefreshToken < ActiveRecord::Base
  belongs_to :user

  before_create :expired_time, :generate_refresh_token

  def expired_time
    self.expire = Time.now + 432000 # 5 days
  end

  def generate_refresh_token
    random_token = SecureRandom.hex(32)
    refresh_token = Base64.urlsafe_encode64(random_token, padding: false)
    hashed_token = BCrypt::Password.create(refresh_token)
    self.refresh_token_hash = hashed_token
  end

  def refresh
    update(expire: expired_time)
    update(refresh_token_hash: generate_refresh_token)
  end
end
