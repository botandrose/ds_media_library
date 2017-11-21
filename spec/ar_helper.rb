require "bundler/setup" # some deps are pulled from git

require "spec_helper"
require "active_record"
require "database_cleaner"
require "byebug"

def silence_stream(stream)
  old_stream = stream.dup
  stream.reopen(RbConfig::CONFIG['host_os'] =~ /mswin|mingw/ ? 'NUL:' : '/dev/null')
  stream.sync = true
  yield
ensure
  stream.reopen(old_stream)
  old_stream.close
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ENV["DATABASE_URL"] = "sqlite3::memory:"

# sqlite3 hates our mysql indexes
ActiveRecord::Migration.class_eval do
  def add_index *; end

  def create_table name, options
    options.delete(:options)
    super
  end
end

DatabaseCleaner.strategy = :transaction
silence_stream(STDOUT) do
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

RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# silence deprecation warning
I18n.enforce_available_locales = true

