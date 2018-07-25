require 'bundler/setup'
require 'cucumber'
require 'chop'
require 'capybara'
require 'capybara/poltergeist'
require 'phantomjs'
require 'byebug'

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new app,
    phantomjs: Phantomjs.path
end
Capybara.default_driver = :poltergeist

require './dummy/app'
Capybara.app = Dummy::App
Capybara.server = :webrick
require "cucumber/rails/capybara"
