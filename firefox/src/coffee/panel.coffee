submit = ()->
  console.log "Submiting data"
  self.port.emit 'done', {
    tags: $('#tags').val().split(/\s*,\s*/),
    description: $("#description").val()
  }

cancel = ()->
  console.log "Canceling"
  self.port.emit 'cancel'

openRoot = ->
  self.port.emit 'openRoot'

$ ()->
  $('#main-form').submit () =>
    submit()
    false

  $("#root_link").click ()->
    openRoot()
    cancel()
    false

  $('body').keydown (event) =>
    if event.key == "Esc"
      cancel()

panel = new Port self.port, ['done', 'cancel'], {
  init: ({name, url, tags, root_link, description, selected_tags})->
    $("#page-name").text name

    $select = $("#tags").selectize
      create: true
      selectOnTab: false
      options: tags.map (item)->
        text: item.tag
        value: item.tag

    selectize = $select[0].selectize
    selectize.focus(false)
    selectize.addItems(selected_tags)




}
