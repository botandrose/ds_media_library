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
  sass:
    .hidden
      display: none

    .media-nest
      display: none

    .expand-input:checked ~ .media-nest
      display: block

    .media-button, .flash-notice, .flash-alert
      text-transform: uppercase

    .modal-input
      opacity: 0.001
      &:checked ~ .modal-wrapper
        left: 0
        opacity: 1
        .modal-content
          display: inline-block
        .modal-bg
          background: white
          opacity: 1

    .modal-wrapper
      position: fixed
      display: -webkit-flex
      display: flex
      top: 0
      left: -100vw
      width: 100vw
      height: 100vh
      z-index: 9999
      text-align: left

    .modal-bg
      background: rgba(#808080, 0.85)
      opacity: 0
      position: absolute
      z-index: 2
      width: 100vw
      height: 100vh
      top: 0
      left: 0

    .modal-content
      display: none
      margin: auto 0
      width: 94vw
      height: 100vh
      padding: 40px
      z-index: 3

    .modal-close
      position: absolute
      top: -10px
      right: 40px
      margin: 0
      width: 40px
      height: 40px
      line-height: 40px
      text-align: center

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

