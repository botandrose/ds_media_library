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
    @$modalToggle.change (event) => @modalToggle(event.target.checked)
    @showPreviews()

  closeModal: ->
    @$modalToggle.prop(checked: false).change()

  modalToggle: (shouldOpen) ->
    if shouldOpen
      @$el.find("[data-load-url]").each (index, el)->
        url = $(el).attr("data-load-url")
        $(el).removeAttr("data-load-url").load(url)
    else
      @showPreviews()

  showPreviews: ->
    @$target.empty()
    selectedMedia = @$el.find("[name=ds_media_library]:checked").toArray()
    contexts = selectedMedia.map (resource, index) => @createContext(resource, index)
    sortedContexts = contexts.sort (a,b) => @sortContexts(a,b) if @ids.length > 0
    previews = sortedContexts.map (context) => @renderTemplate context
    @$target.append previews.join("\n")
    @$target.sortable()

  createContext: (resource, index) ->
    context = @extractContext(resource)
    context.index = index + 1
    context.type = if context.resourcestype == "v" then "video" else "img"
    context.url = "/assets/" + context.resourcespath + context.resourcesfilename
    context.id = parseInt($(resource).attr("value"))
    context

  extractContext: (resource) ->
    obj = {}
    for attr in resource.attributes
      if attr.specified and /^data-/.test(attr.name)
        obj[attr.name.slice(5)] = attr.value
    obj

  sortContexts: (a, b) ->
    if @ids.indexOf(a.id) < @ids.indexOf(b.id)
      -1
    else
      1

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
        searchText = $(this).attr("data-dsml-search-text").toLowerCase()
        isFound = searchText.indexOf(term) != -1
        $(this).toggle isFound

      $tree.find(folderSelector).each ->
        hasFoundResource = $(this).parent().find(resourceSelector + ":visible").length > 0
        $(this).parent().toggle hasFoundResource

    else
      $tree.find(folderSelector).prop checked: false
      $tree.find("li").show()

