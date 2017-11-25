require 'database_cleaner'
require 'database_cleaner/cucumber'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean_with :truncation

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end

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
      t.boolean "hidden", default: false
    end
  end
end

class Widget < ActiveRecord::Base
  ds_resource :cat_picture
  belongs_to_many_ds_resources :dog_pictures
end

