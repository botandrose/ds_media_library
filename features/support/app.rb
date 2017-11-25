require "rails/all"

class TestApp < Rails::Application
  config.secret_key_base = "test"
  config.eager_load = false
end

Rails.logger = Logger.new("/dev/stdout")
Rails.logger = Logger.new("/dev/null")

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

require "ds_media_library"

ENV["DATABASE_URL"] = "sqlite3:tmp/test.sqlite3"

TestApp.initialize!

class InMemoryResolver < ActionView::Resolver
  class_attribute :store
  self.store = Hash.new

  def find_templates(name, prefix, partial, details, outside_app_allowed = false)
    key = [prefix, name].join("/")
    if contents = store[key]
      [ActionView::Template.new(
        contents,
        "app/views/#{key}",
        ActionView::Template.handler_for_extension(:slim),
        virtual_path: key,
        format: :html,
        updated_at: Time.zone.now,
      )]
    else
      []
    end
  end
end

InMemoryResolver.store["layouts/test"] = <<-SLIM
  css:
    .hidden {
      display: none;
    }
    .media-nest {
      display: none;
    }
    .expand-input:checked ~ .media-nest {
      display: block;
    }
    .media-button, .flash-notice, .flash-alert {
      text-transform: uppercase;
    }

    .modal-input {
      opacity: 0.001;
    }
    .modal-input:checked ~ .modal-wrapper {
      left: 0;
      opacity: 1;
    }
    .modal-input:checked ~ .modal-wrapper .modal-content {
      display: inline-block;
    }
    .modal-input:checked ~ .modal-wrapper .modal-bg {
      opacity: 1;
    }
    .modal-wrapper {
      position: fixed;
      display: -webkit-flex;
      display: flex;
      top: 0;
      left: -100vw;
      width: 100vw;
      height: 100vh;
      z-index: 9999;
      text-align: left;
    }
    .modal-bg {
      background: rgba(#808080, 0.85);
      opacity: 0;
      position: absolute;
      z-index: 2;
      width: 100vw;
      height: 100vh;
      top: 0;
      left: 0;
    }
    .modal-content {
      display: none;
      margin: auto 0;
      width: 94vw;
      height: 100vh;
      padding: 40px;
      z-index: 3;
    }
    .modal-close {
      position: absolute;
      top: -10px;
      right: 40px;
      margin: 0;
      width: 40px;
      height: 40px;
      line-height: 40px;
      text-align: center;
    }

  h1 TEST

  nav
    ul
      li = link_to "Widget", "/"
      li = link_to "Manage Media Library", "/media_library"

  .flash-notice = flash.notice
  .flash-alert = flash.alert

  = yield

  = javascript_include_tag "ds_media_library"
SLIM

InMemoryResolver.store["application/show"] = <<-SLIM
  = form_for @widget, url: "/" do |form|
    .field
      = form.label :cat_picture
      = form.media_library :cat_picture

    .field
      = form.label :dog_pictures
      = form.media_library :dog_pictures, multiple: true

    = form.submit "Save"
SLIM

ApplicationController.prepend_view_path InMemoryResolver.new

# sqlite3 hates our mysql indexes
ActiveRecord::Migration.class_eval do
  def add_index *; end

  def create_table name, options
    options.delete(:options)
    super
  end
end

ActiveRecord::Migration.suppress_messages do
  ActiveRecord::Schema.define(version: 20170822210346) do
    create_table "widgets", id: :integer, force: :cascade, options:  "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.integer "cat_picture_id"
      t.string "dog_picture_ids"
    end

    create_table "folders", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "name"
      t.integer "parent_id"
      t.integer "lft", null: false
      t.integer "rgt", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "depth", default: 0, null: false
      t.index ["lft"], name: "index_folders_on_lft"
      t.index ["parent_id"], name: "index_folders_on_parent_id"
      t.index ["rgt"], name: "index_folders_on_rgt"
    end

    create_table "resources", primary_key: "resourcesid", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string "resourcestype"
      t.decimal "resourcesduration", precision: 10, default: "0"
      t.integer "resourceswidth", default: 0
      t.integer "resourcesheight", default: 0
      t.string "resourcesfilename"
      t.string "resourcesoriginalfilename"
      t.string "resourcespath", default: "resources/"
      t.integer "resourcesthumbid"
      t.string "resourceshash"
      t.integer "resourcesparentid", default: 0
      t.integer "resourcesparentindex", default: 0
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.integer "folder_id"
      t.string "case_study_media_title"
      t.boolean "hidden", default: false
    end
  end
end

class Widget < ActiveRecord::Base
  ds_resource :cat_picture
  belongs_to_many_ds_resources :dog_pictures
end

TestApp.routes.draw do
  mount DSMediaLibrary::Engine => "/media_library"
  root to: "application#show"
  patch "/" => "application#update"
end

Capybara.app = TestApp

require 'cucumber/rails/capybara'
