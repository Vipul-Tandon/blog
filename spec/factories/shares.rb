FactoryBot.define do
    factory :share do
      association :user
      association :article
      active { true }
    end
end