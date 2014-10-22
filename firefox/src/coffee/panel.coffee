submit = ()->
  console.log "Submiting data"
  self.port.emit 'done', {
    tags: $('#tags').val().split(/\s*,\s*/),
    description: $("#description").val()
  }

cancel = ()->
  console.log "Canceling"
  self.port.emit 'cancel'

panel = new Port self.port, ['done', 'cancel'], {
  init: ({name, url, tags, root_link})->
    $('body').keydown (event) =>
      if event.key == "Esc"
        cancel()

    $("#page-name").text name
    $("#root_link").click ()->
      self.port.emit 'openRoot'
      false
    $select = $("#tags").selectize
      create: true
      selectOnTab: false
      options: tags.map (item)->
        text: item.tag
        value: item.tag

    selectize = $select[0].selectize
    selectize.focus()

    $('#main-form').submit () =>
      submit()
      false


}
