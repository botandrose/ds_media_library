require 'bundler/setup'
require 'cucumber'
require 'chop'
require 'capybara/headless_chrome'
require 'byebug'

require './dummy/app'
Capybara.app = Dummy::App
Capybara.server = :webrick
require "cucumber/rails/capybara"
