class CreateFolders < ActiveRecord::Migration[4.2]
  def change
    create_table :folders do |t|
      t.string :name
      t.integer :parent_id, index: true
      t.integer :lft, null: false, index: true
      t.integer :rgt, null: false, index: true
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.integer :depth, default: 0, null: false
    end
  end
end

