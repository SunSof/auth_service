require "active_record"
require "bcrypt"
require "securerandom"

class User < ActiveRecord::Base
  has_one :refresh_token

  before_create :generate_guid

  def generate_guid
    self.guid = SecureRandom.uuid
  end
end
