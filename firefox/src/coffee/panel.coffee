describe = (e)->
  for name, value of e
    console.log "#{name}: #{value}"

panel = new Port self.port, ['done'], {
  init: ({name, url})->
    console.log "init"
    $("#page-name").text name
    document.getElementById('main-form').onsubmit = () ->
      console.log "sub false"
      self.port.emit 'done', {tags: 'asa'}
      false
    # $('#main-form').submit ()->
    #   console.log "form submit"
    #   # self.port.emit 'done', 'as'
    #   panel.done $("#tags").value()
    #   true
}
