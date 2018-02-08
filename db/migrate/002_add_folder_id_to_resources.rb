class AddFolderIdToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :folder_id, :integer, null: true, index: true
  end
end

