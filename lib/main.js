var tabs = require("sdk/tabs");
var { Hotkey } = require("sdk/hotkeys");
var data = require("sdk/self").data;
var parser = require("./parser").Parser({
    url: function(){
        return tabs.activeTab.url;
    },
    title: function(){
        return tabs.activeTab.title;
    }
});
var prefs = require('sdk/simple-prefs');
var api = require("./api").api;
var api_url = prefs.prefs['api_url'];

api.setApiUrl(api_url);

prefs.on("api_url", function(prefName){
  api.setApiUrl(prefs.prefs['api_url']);
});



var panel = require("./mypanel").Panel({
  width: 500,
  height: 400,
  contentURL: data.url("panel.html"),
  contentScriptFile: [
      data.url("panel.js"),
      data.url("jquery.min.js"),
      data.url("codemirror/lib/codemirror.js"),
      data.url("codemirror/mode/bookmark/bookmark.js"),
      data.url("codemirror/addon/hint/show-hint.js"),
      data.url("codemirror/addon/hint/bookmark-hint.js"),
      ],
});

var errorCallback = function(response){
  panel.port.emit('panel.error_response', response);
  panel.show();
};




panel.on("show", function() { 
  api.getFolders(function(root){
  	panel.port.emit('panel.set.root', root);
  }, errorCallback);
  panel.port.emit("panel.show", {title: tabs.activeTab.title});
});


panel.port.on('panel.hide', function(){
  panel.hide();
});
panel.port.on('panel.done', function(command){
    var command = parser.parse(command)
    if(command.error){
        return;
    }
    api.sendNode(command, function(response){
      // panel.hide();
    },  errorCallback);
    panel.hide();
});

panel.port.on('panel.change', function(command){
    var command = parser.parse(command);
    panel.port.emit('panel.command.change', command);
   
});

exports.main = function(options) {
    api.getFolders();
    var showHotKey = Hotkey({
      combo: "accel-shift-o",
      onPress: function() {
        if(panel.isShowing)
            panel.hide();
        else
            panel.show();
    }
    });
};


