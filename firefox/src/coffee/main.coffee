{ActionButton} = require "sdk/ui/button/action"
{Panel} = require "sdk/panel"
{Port} = require "port"

console.log "init"

self = require 'sdk/self'
panel = Panel
  contentURL: self.data.url 'panel_main.html'

panelFacade = new Port panel, {
  show: ()->
    console.log "Panel showed"
}
button = ActionButton
  id: 'main-button'
  label: 'Activate menu'
  icon:
    '32': './icons/bookmark-32.png'
  onClick: (state) ->
    panel.show {position: button}
