FactoryGirl.define do
  factory :user do
    username 'default'
    email 'john@doe.com'
    password 'qwerty1234'

    factory :jdoe, parent: :user do
      username 'jdoe'
      email 'jdoe@jdoe.com'
    end

    factory :admin, parent: :user do
      username 'admin'
      email 'admin@admin.com'
      admin true
    end

    factory :user_unconfirmed do
      username 'unconfirmed_user'
      password 'qwerty1234'
      email 'unconfirmed@email.com'
      after :create do |user|
        user.confirmed_at = nil
        user.confirmation_sent_at = nil
        user.save
      end
    end

    # after :create do |user|
    # confirm user for devise
    # user.confirm!
    # end
  end
end
