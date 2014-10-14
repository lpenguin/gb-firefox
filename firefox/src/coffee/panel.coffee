describe = (e)->
  for name, value of e
    console.log "#{name}: #{value}"

panel = new Port self.port, ['done', 'cancel'], {
  init: ({name, url, tags})->
    console.log tags



    $(document).keydown (event)->
      console.log event.relatedTarget
      console.log event.target==document
      console.log event.currentTarget
      if event.key == "Esc"
        self.port.emit 'cancel'

    $("#page-name").text name

    # select = $("#tags").selectize
    #   create: true
    #   options: tags.map (item)->
    #     text: item.tag
    #     value: item.tag

    $("#tags").on 'keydown', (event)->
      console.log "tasg event"
      event.stopPropagation()

    $("#tags").selectize
      create: true
      options: tags.map (item)->
        text: item.tag
        value: item.tag

    $("#description").keydown (event)->
      event.stopPropagation()

    $('#tags').focus()
    document.getElementById('main-form').onsubmit = () ->
      self.port.emit 'done', {
        tags: $('#tags').val().split(/\s*,\s*/),
        description: $("#description").val()
      }
      false
}
