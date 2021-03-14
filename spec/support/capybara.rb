RSpec.configure do |config|
  config.before(:each, type: :system) do
    # driven_by :selenium_chrome_headless
    driven_by :selenium, using: :headless_chrome
  end
end