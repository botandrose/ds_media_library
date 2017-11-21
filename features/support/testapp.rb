require "rails/all"

class TestApp < Rails::Application
  config.secret_key_base = "test"
  config.eager_load = false
end

Rails.logger = Logger.new("/dev/stdout")
# Rails.logger = Logger.new("/dev/null")

class ApplicationController < ActionController::Base
  def self.expose *methods
    methods.each do |method|
      attr_reader method
      helper_method method
    end
  end
end

require "ds_media_library"

ENV["DATABASE_URL"] = "sqlite3:tmp/test.sqlite3"

TestApp.initialize!

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
      t.datetime "expires_at"
      t.boolean "hidden", default: false
    end
  end
end

TestApp.routes.draw do
  mount DSMediaLibrary::Engine => "/media_library"
  root to: redirect("/media_library")
end

Capybara.app = TestApp

require 'cucumber/rails/capybara'
