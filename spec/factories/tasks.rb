FactoryBot.define do
  factory :task do
    project
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { Task.status.values.sample }
  end
end
