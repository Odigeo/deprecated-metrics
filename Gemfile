source 'https://rubygems.org'

gem "rails", "~> 4.0.0"
gem "ocean-rails"

gem "pg"                 # PostgreSQL
gem "foreigner"          # Foreign key constraints in MySQL, PostgreSQL, and SQLite3.

gem "jbuilder"
gem 'rails-patch-json-encode'  # Required for Rails 4.0.x
gem 'oj'

gem "aws-sdk-core" #, "~> 2.0"


group :test, :development do
  gem "sqlite3"            # Dev+testing+CI (staging and production use mySQL)
  gem 'memory_test_fix'    # Makes SQLite run in memory for speed
  gem "rspec-rails", "~> 2.0"
  gem "simplecov", require: false
  gem "factory_girl_rails", "~> 4.0"
  gem "annotate", ">=2.5.0"
  gem "immigrant"
end

gem "protected_attributes"
