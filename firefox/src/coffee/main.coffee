{ActionButton} = require "sdk/ui/button/action"
{Panel} = require "sdk/panel"
{Port} = require "port"
Api = require "api"
tabs = require "sdk/tabs"
self = require 'sdk/self'

console.log Api
panel = Panel
  contentURL: self.data.url 'panel_main.html'
  contentScriptFile: [
    self.data.url('js/port.js')
    self.data.url('js/jquery.js')
    self.data.url('js/panel.js')
  ]

panelPort = new Port panel.port, ['init'], {
  done: ({name, url, description, tags})->
    (Api.addLink {name, url, description, tags}).execute
      success: (res)->
        console.log "success: #{res}"
      error: (res)->
        console.log "error: #{res.statusText}"
}

panel.on 'show', ()->
  tab = tabs.activeTab
  panelPort.init({name: tab.title, url: tab.url})

button = ActionButton
  id: 'main-button'
  label: 'Activate menu'
  icon:
    '32': './icons/bookmark-32.png'
  onClick: (state) ->
    panel.show {position: button}
