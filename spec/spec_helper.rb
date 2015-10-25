require "pry"
require "rails/all"
require "acts_as_permalink"

Dir[File.expand_path("support/**/*.rb", File.dirname(__FILE__))].each { |f| require f }

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
end
