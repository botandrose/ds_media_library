$ ->
  $("[data-toggle-all-checkboxes]").click (event) ->
    event.preventDefault()
    $checkboxes = $(this.getAttribute("data-toggle-all-checkboxes"))
    $checkboxes.prop checked: !$checkboxes.is(":checked")

