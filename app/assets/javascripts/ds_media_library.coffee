#= require jquery
#= require jquery_ujs
#= require jquery-ui/widgets/sortable

$ ->
  $("[data-media-library]").each ->
    new MediaLibrary $(this)

class MediaLibrary
  constructor: (@$el) ->
    baseId = @$el.attr("data-media-library")
    @ids = JSON.parse(@$el.attr("data-media-library-ids"))
    @$el.find(".media-choice:radio").change => @closeModal()
    @template = @$el.find(".media-preview-template")[0].innerHTML
    @$target = $("#selected_media_" + baseId)
    @$modalToggle = $("#" + baseId)
    @$modalToggle.change (event) =>
      if event.target.checked
        @$el.find("[data-load-url]").each (index, el)->
          url = $(el).attr("data-load-url")
          ids = $(el).attr("data-selected-resource-ids")
          $(el).load(url + "&ids=#{ids}")
      else
        @showPreviews()
    @showPreviews()

  closeModal: ->
    @$modalToggle.prop(checked: false).change()

  showPreviews: ->
    @$target.empty()
    $checked_resources = @$el.find(".media-choice:checked")

    previews = $checked_resources.map (index, resource) =>
      @renderTemplate
        index: index + 1
        id: $(resource).attr("value")
        type: $(resource).attr("data-type")
        url: $(resource).attr("data-url")
        filename: $(resource).attr("data-filename")
    previews = previews.toArray().sort (a,b) => @sortPreviews(a,b)
    @$target.append previews.join("\n")
    @$target.sortable()

    ids = $checked_resources.map (index, resource) ->
      $(resource).attr("value")
    .toArray()
    @$el.find("[data-load-url]").each (index, el) ->
      $(el).attr("data-selected-resource-ids", JSON.stringify(ids))

  sortPreviews: (a, b) ->
    aId = @extractId(a)
    bId = @extractId(b)
    if @ids.indexOf(aId) < @ids.indexOf(bId)
      -1
    else
      1

  extractId: (html) ->
    parseInt(html.match(/value="(\d+)"/)[1])

  renderTemplate: (context) ->
    template = @template
    for key, value of context
      template = template.replace ///{{#{key}}}///g, value
    template

$ ->
  $("[data-toggle-all-checkboxes]").click (event) ->
    event.preventDefault()
    $checkboxes = $(this.getAttribute("data-toggle-all-checkboxes"))
    $checkboxes.prop checked: !$checkboxes.is(":checked")

