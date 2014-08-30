describe = (e)->
  for name, value of e
    console.log "#{name}: #{value}"

panel = new Port self.port, ['done'], {
  init: ({name, url})->
    $("#page-name").text name

    document.getElementById('main-form').onsubmit = () ->
      self.port.emit 'done', {
        tags: $('#tags').val().split(","),
        description: "", 
        url: url, 
        name: name
      }
      false
}
