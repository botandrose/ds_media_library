require "active_support/number_helper"

module DSMediaLibrary
  module FormHelper
    def media_library field, label: field.to_s.humanize, multiple: false, optional: false, dimensions: nil, helptext: nil, preview: true, required: false
      helper = MediaLibrary.new(object.send(field), field, label, multiple, optional, dimensions, helptext, preview, required)
      @template.render "ds_media_library/form_helper/media_library_helper", form: self, helper: helper
    end

    class MediaLibrary < Struct.new(:object, :field, :label, :multiple, :optional, :dimensions, :helptext, :preview, :required)
      def ids
        Array(object).map(&:id)
      end

      def single_field
        field.to_s.singularize.to_sym
      end

      def file_field_name
        if multiple
          :"new_#{single_field}_files"
        else
          :"#{field}_file"
        end
      end

      def remove_field_name
        if multiple
          :"remove_#{single_field}_ids"
        else
          :"remove_#{field}"
        end
      end

      def field_id_name
        if multiple
          :"#{single_field}_ids"
        else
          :"#{field}_id"
        end
      end

      def html_id
        "media-modal-#{field}"
      end

      def label_css_class
        "optional" if optional
      end

      def helptext
        super || dimensions.present? && "#{label.pluralize} must be #{number_with_delimiter(width)}px wide by #{number_with_delimiter(height)}px tall."
      end

      def width
        dimensions.split("x").first if dimensions
      end

      def height
        dimensions.split("x").last if dimensions
      end

      def root
        @root ||= Folder.root
      end

      def root_folders
        root.children
      end

      def root_resources
        root.resources
      end

      def original_file_name
        object.original_file_name if object.present?
      end

      private

      def number_with_delimiter number
        ActiveSupport::NumberHelper.number_to_delimited(number)
      end
    end
  end
end
