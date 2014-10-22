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
  init: ({name, url, tags})->
    $('body').keydown (event) =>
      if event.key == "Esc"
        cancel()

    $("#page-name").text name

    $select = $("#tags").selectize
      create: true
      selectOnTab: false
      options: tags.map (item)->
        text: item.tag
        value: item.tag

    selectize = $select[0].selectize
    selectize.focus()
    # selectize.on 'dropdown_open', ()-> self.dropdown_open = true
    # selectize.on 'dropdown_close', ()-> self.dropdown_open = false
    #
    # selectize.$control_input.keydown (event)->
    #   if event.key == "Esc"
    #     event.stopPropagation()
      # console.log "tags keydown"
      # console.log "drop #{self.dropdown_open}"
      # console.log selectize.$dropdown.is ":visible"
      #
      # if selectize.$dropdown.is ":visible"
      #   # console.log "blocking tags event"
      #   event.stopPropagation()

    # $('#tags').focus()

    $('#main-form').submit () =>
      submit()
      false


}
