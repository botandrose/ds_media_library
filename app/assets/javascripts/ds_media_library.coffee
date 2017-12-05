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
    @template = @$el.find("#dsml-media-preview-template")[0].innerHTML
    @$el.on "change", "[name=ds_media_library]:radio", => @closeModal()
    @$target = $("#dsml-selected-media-" + baseId)
    @$modalToggle = $("#" + baseId)
    @$modalToggle.change (event) =>
      if event.target.checked
        @$el.find("[data-load-url]").each (index, el)->
          url = $(el).attr("data-load-url")
          $(el).removeAttr("data-load-url").load(url)
      else
        @showPreviews()
    @showPreviews()

  closeModal: ->
    @$modalToggle.prop(checked: false).change()

  showPreviews: ->
    @$target.empty()
    previews = @$el.find("[name=ds_media_library]:checked").map (index, resource) =>
      @renderTemplate
        index: index + 1
        id: $(resource).attr("value")
        type: $(resource).attr("data-type")
        url: $(resource).attr("data-url")
        filename: $(resource).attr("data-filename")
    previews = previews.toArray().sort (a,b) => @sortPreviews(a,b)
    @$target.append previews.join("\n")
    @$target.sortable()

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
  $("body").on "click", "[data-dsml-toggle-all-checkboxes]", (event) ->
    event.preventDefault()
    $checkboxes = $($(this).attr("data-dsml-toggle-all-checkboxes"))
    $checkboxes.prop checked: !$checkboxes.is(":checked")

$ ->
  $("body").on "keyup", "#dsml-search-media", (event) ->
    folderSelector = $("[data-dsml-toggle-all-checkboxes]").attr("data-dsml-toggle-all-checkboxes")
    resourceSelector = $("[data-dsml-search-media]").attr("data-dsml-search-media")
    $tree = $(this).siblings("#dsml-media-tree")
    term = event.target.value.toLowerCase()

    if term.length > 0
      $tree.find(folderSelector).prop checked: true

      $tree.find(resourceSelector).each ->
        labelText = $(this).find("label").text().toLowerCase()
        isFound = labelText.indexOf(term) != -1
        $(this).toggle isFound

      $tree.find(folderSelector).each ->
        hasFoundResource = $(this).parent().find(resourceSelector).length > 0
        $(this).parent().toggle hasFoundResource

    else
      $tree.find(folderSelector).prop checked: false
      $tree.find("li").show()

