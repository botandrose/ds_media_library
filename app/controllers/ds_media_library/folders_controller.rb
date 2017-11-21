module DSMediaLibrary
  class FoldersController < ApplicationController
    expose :folder

    def new
      @folder = DSMediaLibrary::Folder.new
      render "ds_media_library/resources/folder_form"
    end

    def create
      DSMediaLibrary::Folder.create! params[:folder]
      redirect_to :resources, notice: "Folder created"
    end

    def edit
      @folder = DSMediaLibrary::Folder.find(params[:id])
      render "ds_media_library/resources/folder_form"
    end

    def update
      DSMediaLibrary::Folder.update params[:id], params[:folder]
      redirect_to :resources, notice: "Folder updated"
    end

    def destroy
      DSMediaLibrary::Folder.destroy params[:id]
      redirect_to :resources, notice: "Folder deleted"
    end
  end
end

