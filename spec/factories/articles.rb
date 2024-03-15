FactoryBot.define do
    factory :article do
      title { Faker::Lorem.word }
      body { Faker::Lorem.sentence}
      status { "public" }
      association :user, factory: :user


      after(:create) do |article|
        create_list(:comment, 3, article: article)
      end
    end
end