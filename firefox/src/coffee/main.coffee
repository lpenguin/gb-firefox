{ActionButton} = require "sdk/ui/button/action"
{Panel} = require "sdk/panel"
{Port} = require "port"
tabs = require "sdk/tabs"
self = require 'sdk/self'
panel = Panel
  contentURL: self.data.url 'panel_main.html'
  contentScriptFile: [
    self.data.url('js/port.js')
    self.data.url('js/jquery.js')
    self.data.url('js/panel.js')
  ]

panelPort = new Port panel.port, ['init'], {
  done: ({tags})->
    console.log "TAGS: #{tags}"
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
