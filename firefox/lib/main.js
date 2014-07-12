var ActionButton, Panel, button, panel, self;

ActionButton = require("sdk/ui/button/action").ActionButton;

Panel = require("sdk/panel").Panel;

console.log("init");

self = require('sdk/self');

panel = Panel({
  contentURL: self.data.url('panel_main.html')
});

button = ActionButton({
  id: 'main-button',
  label: 'Activate menu',
  icon: {
    '32': './icons/bookmark-32.png'
  },
  onClick: function(state) {
    return panel.show({
      position: button
    });
  }
});
