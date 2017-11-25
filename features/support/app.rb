require "rails/all"
require "ds_media_library"

class TestApp < Rails::Application
  config.secret_key_base = "test"
  config.eager_load = false
  config.logger = Logger.new("/dev/stdout")
  config.logger = Logger.new("/dev/null")
end

ENV["DATABASE_URL"] = "sqlite3:tmp/test.sqlite3"

TestApp.initialize!

Capybara.app = TestApp
require "cucumber/rails/capybara"

class ApplicationController < ActionController::Base
  def self.expose *methods
    methods.each do |method|
      attr_reader method
      helper_method method
    end
  end

  layout "test"

  def show
    @widget = Widget.first_or_create!
  end

  def update
    Widget.first_or_create!.update! params.require(:widget).permit!
    redirect_to "/", notice: "Widget updated"
  end
end

TestApp.routes.draw do
  mount DSMediaLibrary::Engine => "/media_library"
  root to: "application#show"
  patch "/" => "application#update"
end

After do
  Rails.public_path.rmtree # soft delete leaves files in place
end
