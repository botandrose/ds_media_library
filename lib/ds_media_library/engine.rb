require "ds_node"
require "slim"
require "sassc-rails"
require "font-awesome-rails"
require "jquery-rails"
require "jquery-ui-rails"
require "coffee-rails"

module DSMediaLibrary
  class Engine < Rails::Engine
    initializer "ds_media_library.form_helper" do
      config.after_initialize do
        ActionView::Helpers::FormBuilder.class_eval do
          prepend FormHelper
        end
      end
    end

    initializer "ds_media_library.ds_node" do
      config.after_initialize do
        DSNode::Resource.class_eval do
          belongs_to :folder, class_name: "DSMediaLibrary::Folder", required: false

          def css_class
            "dsml-media-link"
          end

          def type_name
            case media_type
            when "i" then "Image"
            when "v" then "Video"
            when "a" then "Audio"
            when "p" then "PDF"
            else "Unknown"
            end
          end

          def updated_on
            updated_at.try(:to_date)
          end
        end
      end
    end

    initializer "ds_media_library.assets" do
      config.assets.precompile += %w( ds_media_library.css ds_media_library.js )
    end

    isolate_namespace DSMediaLibrary
  end
end

