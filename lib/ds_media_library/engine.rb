require "ds_node"
require "slim"

module DSMediaLibrary
  class Engine < Rails::Engine
    initializer "ds_media_library.form_helper" do
      ActionView::Helpers::FormBuilder.class_eval do
        prepend FormHelper
      end
    end

    initializer "ds_media_library.ds_node" do
      DSNode::Resource.class_eval do
        belongs_to :folder, class_name: "DSMediaLibrary::Folder", required: false
      end
    end

    isolate_namespace DSMediaLibrary
  end
end

