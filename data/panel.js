var inited = false;
var last_type = null;
var last_folder = null;
var root = null;
var editor = null;
var completed;

self.port.on('panel.set.root', function(root_){
    root = root_;
});

self.port.on("panel.show", function(args) {
    if(!inited)
        panel_init();
    $("#current_page").text(args.title);
    // var value = editor.getValue();
    
    // if(last_type){
    //     value = (last_type);
    //     if(last_folder)
    //         value = (value +"\nfolder "+last_folder);  
    // }else
    //     value = ("bookmark");

    // editor.setValue(value);
    editor.focus();
    editor.setCursor({line:editor.lastLine(), ch: 109999999})    

});

self.port.on('panel.error_response', function(reponse){
  $("#error").text("There was an error");
  $("#error").show();
});

self.port.on('panel.command.change', function(command){
    $(".status").text("");
    if(command){
        $("#command_folder").text(command.folder);
        $("#command_type").text(command.type);
        $("#command_text").text(command.text);
        $("#command_error").text(command.error);
        last_type = command.type;
        last_folder = command.folder;
    }
    else
        $("#command_status").text("Parse error");
});

function panel_init() {
    console.log('panel_init');
    var command = $("#command");

    $("#error").click(function(){
      $(this).hide();
    });

    if(editor == null){
        editor = CodeMirror.fromTextArea(document.getElementById("command"), {
                lineNumbers: true,
                mode: "bookmark",
                lineWrapping: true
              });

        editor.on("cursorActivity", function(ed){
        if (completed)
          completed = false;
        else
          if(CodeMirror.bookmarkHint_isPrevFolder(editor)){
            setTimeout(function(){
              CodeMirror.showHint(ed, CodeMirror.bookmarkHint, {root: root, completeSingle: false}); 
            }, 10);  
          }else{
              CodeMirror.showHint(ed, CodeMirror.bookmarkHint, {root: root, completeSingle: false}); 
          }
      });

      editor.on("endCompletion", function(ed){
        completed = true;
      });
      
     
      $("body").keypress(function(event){
        // console.log("key press: "+event.keyCode+ " " + event.which);
        if(event.which == 13 && event.ctrlKey){
            self.port.emit('panel.done', editor.getValue());
        }

        if(event.which == 99 && event.ctrlKey){
          self.port.emit('panel.hide');
        }
      });

      editor.on("change", function(editor, event){
        //console.log("change");
        //if(event.which == 13 && event.ctrlKey){
        //    
        //}else{
            self.port.emit('panel.change', editor.getValue());
        //}
    });
    }
    
    inited = true;
};