module DSMediaLibrary
  class ResourcesController < ApplicationController
    expose :root, :resource, :folders

    def index
      @root = DSMediaLibrary::Folder.root
      @folders = folders_with_children
    end

    def new
      @resource = DSNode::Resource.new
      render :form
    end

    def create
      params[:ds_node_resource][:file].each do |file|
        DSNode::Resource.create! params[:ds_node_resource].merge(file: file)
      end
      redirect_to :resources, notice: "Media created"
    end

    def edit
      render :form
    end

    def update
      resource.update! params[:ds_node_resource]
      # FIXME extract to DSNode gem
      resource.update! original_file_name: params[:ds_node_resource][:file].original_filename if params[:ds_node_resource][:file]
      redirect_to :resources, notice: "Media updated"
    end

    def destroy
      resource.update! hidden: true
      redirect_to :resources, notice: "Media deleted"
    end

    def move_many
      DSNode::Resource.where(resourcesid: params[:resource_ids]).update folder_id: params[:folder_id]
      redirect_to :resources, notice: "Media updated"
    end

    private

    def resource
      @resource ||= DSNode::Resource.find(params[:id])
    end

    def folders_with_children
      recurse_folders(DSMediaLibrary::Folder.roots.sort_by(&:name))
    end

    def recurse_folders folders
      folders.flat_map do |folder|
        [folder] + recurse_folders(folder.children)
      end
    end
  end
end

