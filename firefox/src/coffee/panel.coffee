describe = (e)->
  for name, value of e
    console.log "#{name}: #{value}"

panel = new Port self.port, ['done'], {
  init: ({name, url, tags})->
    console.log tags
    $("#page-name").text name
    $('#tags').focus()
    $("#tags").selectize
      options: tags.map (item)->
        text: item.tag
        value: item.tag
        
    document.getElementById('main-form').onsubmit = () ->
      self.port.emit 'done', {
        tags: $('#tags').val().split(/\s*,\s*/),
        description: $("#description").val()
      }
      false
}
