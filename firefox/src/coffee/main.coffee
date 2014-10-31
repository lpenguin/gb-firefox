{ActionButton} = require "sdk/ui/button/action"
{Panel} = require "./mypanel"

tabs = require "sdk/tabs"
self = require 'sdk/self'
{ getFavicon } = require("sdk/places/favicon");
{ Hotkey } = require("sdk/hotkeys")

{Port} = require "port"
Api = require "api"
{Link} = require 'models'
promise = require 'sdk/core/promise'

apiRoot = require("sdk/simple-prefs").prefs.api_url

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

panelPort = new Port panel.port, ['init'],
  done: ({description, tags})->
    console.log "panel done"
    name = tabs.activeTab.title
    url = tabs.activeTab.url
    faviconUrl = ""
    link = new Link({name, url, description, tags, faviconUrl})
    Api.addLink link
    panel.hide()

  cancel: ()-> panel.hide()

  openRoot: ()-> tabs.open apiRoot

showPanel = ()->
  panel.show {position: button}

panel.on 'show', ()->
  tab = tabs.activeTab
  promise.all([Api.tags(), Api.findUrl(tab.url)]).then (res)->
    tags = res[0].result
    record = res[1].result
    panelPort.init({name: tab.title, url: tab.url, tags: tags, record:record})

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
    if not panel.isShowing
      showPanel()
    else
      panel.hide()
