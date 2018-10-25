RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.after(:each) { Warden.test_reset! }
end

# enable login_as helpers from devise
Warden.test_mode!
include Warden::Test::Helpers
