require "ds_node"
require "slim"
require "sass-rails"
require "jquery-rails"
require "jquery-ui-rails"
require "coffee-rails"

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

        def css_class
          "media-link"
        end
      end
    end

    initializer "ds_media_library.assets" do
      config.assets.precompile += %w( ds_media_library.css ds_media_library.js )
    end

    isolate_namespace DSMediaLibrary
  end
end

