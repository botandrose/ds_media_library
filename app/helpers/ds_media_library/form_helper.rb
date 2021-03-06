require "active_support/number_helper"

module DSMediaLibrary
  module FormHelper
    def media_library field, label: field.to_s.humanize, multiple: false, optional: false, dimensions: nil, helptext: nil, preview: true, required: false, &block
      selected_ids = Array(object.send(field)).map(&:id)
      helper = MediaLibrary.new(selected_ids, field, label, multiple, optional, dimensions, helptext, preview, required)
      @template.render "ds_media_library/form_helper/media_library_helper", form: self, helper: helper, &block
    end

    class MediaLibrary < Struct.new(:ids, :field, :label, :multiple, :optional, :dimensions, :helptext, :preview, :required)
      def self.from_params params
        new(
          Array(params[:ids] || []).map(&:to_i),
          params[:field],
          params[:label],
          params[:multiple] == "true",
          params[:optional] == "true",
          params[:dimensions],
          params[:helptext],
          params[:preview] == "true",
          params[:required] == "true",
        )
      end

      def selected_resources
        DSNode::Resource.find(ids)
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

      def field_id_name
        if multiple
          :"#{single_field}_ids"
        else
          :"#{field}_id"
        end
      end

      def field_type
        multiple ? "checkbox" : "radio"
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

      private

      def number_with_delimiter number
        ActiveSupport::NumberHelper.number_to_delimited(number)
      end
    end
  end
end
