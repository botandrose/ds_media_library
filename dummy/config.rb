module Dummy; end

class Dummy::App < Rails::Application
  config.secret_key_base = "test"
  config.eager_load = false
  config.logger = Logger.new("/dev/stdout")

  initializer "log level" do
    Rails.logger.level = Logger::WARN
  end
end

ENV["DATABASE_URL"] = "sqlite3:tmp/test.sqlite3"

Dummy::App.initialize!

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
    widget = Widget.first_or_create!
    widget_params = params.require(:widget).permit!
    widget.update! widget_params
    redirect_to "/", notice: "Widget updated"
  end
end

Dummy::App.routes.draw do
  mount DSMediaLibrary::Engine => "/media_library"
  root to: "application#show"
  patch "/" => "application#update"
end

# app's soft delete leaves files in place, so clean them up
at_exit do
  begin
    Rails.public_path.rmtree
  rescue Errno::ENOENT
  end
end

