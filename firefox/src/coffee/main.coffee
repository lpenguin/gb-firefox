{ActionButton} = require "sdk/ui/button/action"
{Panel} = require "./mypanel"

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
    self.data.url('js/selectize.js')
  ]

panelPort = new Port panel.port, ['init'], {
  done: ({description, tags})->
    name = tabs.activeTab.title
    url = tabs.activeTab.url
    faviconUrl = ""
    link = new Link({name, url, description, tags, faviconUrl})
    sendLink link
    panel.hide()
  cancel: ()->
    panel.hide()
}

updateTags = ({success, error})->
  Api.tags().execute
    success: (res)->
      success(res)

    error: (res)->
      error(res)

showPanel = ()->
  panel.show {position: button}

sendLink = (link)->
  (Api.addLink link).execute
    success: (res)->
      console.log "success: #{JSON.stringify(res)}"
    error: (res)->
      console.log "error: #{res.statusText}"

panel.on 'show', ()->
  tab = tabs.activeTab
  updateTags
    success: (res)->
      panelPort.init({name: tab.title, url: tab.url, tags: res.result})
    error: (res)->
      console.log "#{JSON.stringify(res)}"

hk = Hotkey
  combo: "accel-shift-s"
  onPress: () ->
    showPanel()

button = ActionButton
  id: 'main-button'
  label: 'Activate menu'
  icon:
    '32': './icons/bookmark-32.png'
  onClick: (state) ->
    showPanel()
