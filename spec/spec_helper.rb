
RSpec.configure do |config|
  config.mock_with :flexmock
end

def fixture(*components)
  File.join(
    File.dirname(__FILE__), 
    'fixtures', 
    *components)
end