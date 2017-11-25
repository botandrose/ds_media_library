class InMemoryResolver < ActionView::Resolver
  cattr_accessor(:store) { Hash.new }

  def find_templates(name, prefix, partial, details, outside_app_allowed = false)
    key = [prefix, name].join("/")
    if contents = store[key]
      [ActionView::Template.new(
        contents,
        "app/views/#{key}",
        ActionView::Template.handler_for_extension(:slim),
        virtual_path: key,
        format: :html,
        updated_at: Time.zone.now,
      )]
    else
      []
    end
  end
end

ApplicationController.prepend_view_path InMemoryResolver.new

InMemoryResolver.store["layouts/test"] = <<-SLIM
  = stylesheet_link_tag "ds_media_library"

  h1 TEST

  nav
    ul
      li = link_to "Widget", "/"
      li = link_to "Manage Media Library", "/media_library"

  .flash-notice = flash.notice
  .flash-alert = flash.alert

  = yield

  = javascript_include_tag "ds_media_library"
SLIM

InMemoryResolver.store["application/show"] = <<-SLIM
  = form_for @widget, url: "/" do |form|
    .field
      = form.label :cat_picture
      = form.media_library :cat_picture

    .field
      = form.label :dog_pictures
      = form.media_library :dog_pictures, multiple: true

    = form.submit "Save"
SLIM

