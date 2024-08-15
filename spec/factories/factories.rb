FactoryBot.define do
  factory :user do
    guid { SecureRandom.uuid }
    sequence(:email) { |n| "user#{n}@example.com" }
  end

  factory :refresh_token do
    refresh_token_hash { BCrypt::Password.create(SecureRandom.hex(32)) }
    expire { Time.now }
    ip { "127.0.0.1" }

    after(:build) do |refresh_token|
      if refresh_token.user
        refresh_token.user_guid = refresh_token.user.guid
      end
    end
  end
end
