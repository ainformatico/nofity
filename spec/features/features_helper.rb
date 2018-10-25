require 'spec_helper'
require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app,
                                    timeout: 60,
                                    phantomjs_logger: File.open('log/phantomjs.log', 'a+'))
end

Capybara.javascript_driver = ENV.fetch('JSDRIVER', 'poltergeist').to_sym
Capybara.default_max_wait_time = ENV['JENKINS'].present? ? 30 : 10

def fake_sign_in(username)
  developers = YAML.load_file("#{Rails.root}/spec/fixtures/users.yml")
  user = developers[username]

  new_user = create(:user, email: user['email'], password: user['password'], admin: user['admin'])

  login_as(new_user, scope: :user)

  SimpleConfig.for :application do
    set :fake_user_id, new_user.id
  end

  new_user
end

def clear_fake_sign_in
  SimpleConfig.for :application do
    unset :fake_user_id if respond_to?(:fake_user_id)
  end
end

def wait_for_ajax
  Timeout.timeout(Capybara.default_max_wait_time) do
    active = page.evaluate_script('jQuery.active')
    active = page.evaluate_script('jQuery.active') until active == 0
  end
rescue Capybara::Poltergeist::JavascriptError
  # Some tests don't visit any page
end

RSpec.configure do |c|
  # By first defining the after hook for the fake sign in and then the one for the ajax calls
  # we make sure that the last one defined will be run first. In other words, we should
  # see in the log:
  # 1. Waiting for remaining AJAX calls
  # 2. Clearing the fake_sign_in
  c.after do
    Rails.logger.debug 'CLEANUP: Clearing the fake_sign_in'
    clear_fake_sign_in
  end

  c.after(:each, js: true) do
    Rails.logger.debug 'CLEANUP: Waiting for remaining AJAX calls'
    wait_for_ajax
  end
end
