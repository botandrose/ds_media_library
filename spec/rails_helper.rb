require "rails/all"

class TestApp < Rails::Application
  config.secret_key_base = "test"
end

Rails.logger = Logger.new("/dev/stdout")

class ApplicationController < ActionController::Base
  def self.expose *methods
    methods.each do |method|
      attr_reader method
      helper_method method
    end
  end
end

