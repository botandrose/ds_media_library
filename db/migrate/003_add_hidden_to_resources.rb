class AddHiddenToResources < ActiveRecord::Migration[4.2]
  def change
    add_column :resources, :hidden, :boolean, default: false
  end
end
