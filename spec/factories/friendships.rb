FactoryBot.define do
    factory :friendship do
        association :user, factory: :user
        association :friend, factory: :user
        status { "pending" }
    

        trait :accepted do
            status { "accepted" }
        end
    
        trait :declined do
            status { "declined" }
            cooldown { 30.days.from_now }
        end
    end
end
  