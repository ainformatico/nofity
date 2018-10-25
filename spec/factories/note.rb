FactoryGirl.define do
  factory :note do
    content 'default note content'

    factory :note_public do
      content 'default public note content'
      public true
    end
  end
end
