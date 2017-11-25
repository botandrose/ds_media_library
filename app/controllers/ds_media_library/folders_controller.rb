module DSMediaLibrary
  class FoldersController < ApplicationController
    expose :folder

    def new
      @folder = DSMediaLibrary::Folder.new
      render "ds_media_library/manage/folders/form"
    end

    def create
      DSMediaLibrary::Folder.create! folder_params
      redirect_to :resources, notice: "Folder created"
    end

    def edit
      @folder = DSMediaLibrary::Folder.find(params[:id])
      render "ds_media_library/manage/folders/form"
    end

    def update
      DSMediaLibrary::Folder.update params[:id], folder_params
      redirect_to :resources, notice: "Folder updated"
    end

    def destroy
      DSMediaLibrary::Folder.destroy params[:id]
      redirect_to :resources, notice: "Folder deleted"
    end

    private

    def folder_params
      params.require(:folder).permit(:parent_id, :name)
    end
  end
end

