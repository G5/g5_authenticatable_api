FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user.#{n}@test.host" }
    provider 'g5'
    sequence(:uid) { |n| "remote-user-#{n}" }
    sequence(:g5_access_token) { |n| "token-abc123-#{n}" }
  end
end
