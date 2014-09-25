{ActionButton} = require "sdk/ui/button/action"
{Panel} = require "sdk/panel"
tabs = require "sdk/tabs"
self = require 'sdk/self'
{ getFavicon } = require("sdk/places/favicon");
{ Hotkey } = require("sdk/hotkeys")

{Port} = require "port"
Api = require "api"
{Link} = require 'models'

panel = Panel
  height: 380
  width: 300
  contentURL: self.data.url 'panel_main.html'
  contentScriptFile: [
    self.data.url('js/port.js')
    self.data.url('js/jquery.js')
    self.data.url('js/panel.js')
  ]

panelPort = new Port panel.port, ['init'], {
  done: ({description, tags})->
    name = tabs.activeTab.title
    url = tabs.activeTab.url
    faviconUrl = ""
    link = new Link({name, url, description, tags, faviconUrl})
    sendLink link
    panel.hide()
}

sendLink = (link)->
  (Api.addLink link).execute
    success: (res)->
      console.log "success: #{JSON.stringify(res)}"
    error: (res)->
      console.log "error: #{res.statusText}"

panel.on 'show', ()->
  tab = tabs.activeTab
  panelPort.init({name: tab.title, url: tab.url})

hk = Hotkey
  combo: "accel-shift-s"
  onPress: () ->
    panel.show {position: button}

button = ActionButton
  id: 'main-button'
  label: 'Activate menu'
  icon:
    '32': './icons/bookmark-32.png'
  onClick: (state) ->
    panel.show {position: button}
