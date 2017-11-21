require "awesome_nested_set"
require "ds_node"

module DSMediaLibrary
  class Folder < ActiveRecord::Base
    self.table_name = :folders

    def self.root
      klass = Struct.new(:children, :resources)
      children = Folder.roots.to_a.sort_by(&:name)
      resources = DSNode::Resource.where(folder_id: nil).order(:original_file_name)
      klass.new(children, resources)
    end

    acts_as_nested_set

    has_many :resources, -> { order(:original_file_name) }, class_name: "DSNode::Resource"

    def children
      super.order(:name)
    end

    def all_folders
      self.class.all
    end

    before_destroy :move_all_contents_to_parent!

    private

    def move_all_contents_to_parent!
      transaction do
        resources.each do |resource|
          resource.update! folder: parent
        end
        children.each do |resource|
          resource.update! parent: parent
        end
      end
    end
  end
end

