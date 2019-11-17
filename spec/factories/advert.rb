include ActionDispatch::TestProcess

FactoryBot.define do
  factory :advert do
    title { Faker::Vehicle.make_and_model }
    description { Faker::Vehicle.standard_specs }
    car_foto { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', "car-#{rand(1..9)}.jpg"), 'image/jpg') }
    price { Faker::Number.decimal(l_digits: 2) }
  end
end
