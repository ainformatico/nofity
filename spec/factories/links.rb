# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :link do
    url 'https://nofity.com'
    title 'link title'
    description 'link description'
    deleted false
  end
end
