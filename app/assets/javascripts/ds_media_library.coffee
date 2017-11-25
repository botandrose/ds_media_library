#= require jquery
#= require jquery_ujs
#= require jquery-ui/widgets/sortable
#= require toggle_all_checkboxes

$ ->
  $("[data-media-library]").each ->
    new MediaLibrary $(this)

class MediaLibrary
  constructor: (@$el) ->
    baseId = @$el.attr("data-media-library")
    @ids = JSON.parse(@$el.attr("data-media-library-ids"))
    @$el.find(".media-choice:radio").change => @closeModal()
    @$target = $("#selected_media_" + baseId)
    @$modalToggle = $("#" + baseId)
    @$modalToggle.change (event) =>
      @showPreviews() unless event.target.checked
    @showPreviews()

  closeModal: ->
    @$modalToggle.prop(checked: false).change()

  showPreviews: ->
    @$target.empty()
    previews = @$el.find(".media-choice:checked ~ .media-preview-template").map (index, template) =>
      template.innerHTML.replace(/{{index}}/g, index + 1)
    previews = previews.toArray().sort (a,b) => @sortPreviews(a,b)
    @$target.append previews.join("\n")
    @$target.sortable()

  isMultiple: ->
    @$el.find(".media-choice").is(":checkbox")

  sortPreviews: (a, b) ->
    aId = @extractId(a)
    bId = @extractId(b)
    if @ids.indexOf(aId) < @ids.indexOf(bId)
      -1
    else
      1

  extractId: (html) ->
    parseInt(html.match(/value="(\d+)"/)[1])

