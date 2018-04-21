require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.allow_remote_database_url = true # sqlite:// counts as remote. PR?
DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

