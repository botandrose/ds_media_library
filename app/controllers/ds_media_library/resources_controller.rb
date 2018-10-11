module DSMediaLibrary
  class ResourcesController < ApplicationController
    expose :root, :resource, :folders

    def index
      @root = DSMediaLibrary::Folder.root
      @folders = folders_with_children
      render "ds_media_library/manage/index"
    end

    def new
      @resource = DSNode::Resource.new
      render "ds_media_library/manage/resources/form"
    end

    def create
      resources_params.each do |resource_params|
        DSNode::Resource.create! resource_params
      end
      redirect_to :resources, notice: "Media created"
    end

    def edit
      render "ds_media_library/manage/resources/form"
    end

    def update
      resource.update! resource_params
      redirect_to :resources, notice: "Media updated"
    end

    def destroy
      DSNode::Resource.where(resourcesid: params[:resource_ids]).update hidden: true
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

    def resource_params
      resource_params = params.require(:ds_node_resource).permit(:folder_id, :file)
      # FIXME extract to DSNode gem
      resource_params.merge!(original_file_name: params[:ds_node_resource][:file].original_filename) if params[:ds_node_resource][:file]
      resource_params
    end

    def resources_params
      params[:ds_node_resource][:file].map do |file|
        params.require(:ds_node_resource).permit(:folder_id).merge(file: file)
      end
    end
  end
end

