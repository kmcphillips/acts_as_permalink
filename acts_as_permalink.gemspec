$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "acts_as_permalink/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "acts_as_permalink"
  s.version     = Acts::Permalink::VERSION
  s.authors     = ["Kevin McPhillips"]
  s.email       = ["github@kevinmcphillips.ca"]
  s.homepage    = "http://github.com/kmcphillips/acts_as_permalink"
  s.summary     = "Automatically manage permalink fields for ActiveRecord models in Rails."
  s.description = "Manages permalink columns in active record models. Strips special characters and spaces, creates before validation, assures uniqueness. That kind of thing."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", ">= 4.0"

  s.add_development_dependency "rspec"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "pry"
  s.add_development_dependency "database_cleaner"
end
