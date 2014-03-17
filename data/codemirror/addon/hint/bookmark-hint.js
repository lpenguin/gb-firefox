(function () {
  var Pos = CodeMirror.Pos;

  var findChild = function(folder, childName){
    if(folder.children == null)
      return null;

    for (var i = 0; i < folder.children.length; i++) {
      if(folder.children[i].name == childName)
        return folder.children[i];
    }
    return null;
  };

  var getFolderByPath = function(root, pathTokens){
    var cur = root;
    for (var i = 0; i < pathTokens.length; i++) {
      var child = findChild(cur, pathTokens[i]);
      if(child == null)
        return null;
      cur = child;
    }

    return cur;
  };

  var startsWith = function(str1, str2){
    return str1.indexOf(str2) == 0
  }
  var getChildrenNames = function(folder, filter){
    var names = [];
    for(var i  in folder.children){
      var name = folder.children[i].name;
      if( !filter || filter && startsWith(name, filter))
        names.push(name);
    }
    return names;
  }
  var types = ['bookmark', 'note', 'todo'];
  var prevFolder = function(editor){
      var cur = editor.getCursor();
      var line = editor.getLine(cur.line).substring(0, cur.ch);
      // console.log("line: '"+line+"'");
      //var prevToken = editor.getTokenAt({line:cur.line, ch: cur.ch-2});    
      return line.match(/^folder\s+/);
  };

  var filterArr = function(arr, strStart){
    var res = [];
    for (var i = 0; i < arr.length; i++) {
      if(startsWith(arr[i], strStart))
        res.push(arr[i]);
    }
    return res;
  }

  CodeMirror.bookmarkHint_isPrevFolder = function(editor){
    return prevFolder(editor);
  }
  CodeMirror.bookmarkHint = function(editor, options) {
    var root = options.root;

    var cur = editor.getCursor();
    var token = editor.getTokenAt(cur);

    if(token.type == "variable" ){
      str = token.string.substring(0, cur.ch - token.start);
      var pathTokens = str.split('.');
      var filter = pathTokens.pop();
      var folder = getFolderByPath(root, pathTokens);
      var hints = getChildrenNames(folder, filter);
      
      if(hints.length == 1 && filter == hints[0])
        return false;
      
      var start = pathTokens.join('.').length + token.start ;


      if(pathTokens.length)
        start++;
      // hints.push('aa');
      
      
      return {
        list: hints,
        from: Pos(cur.line, start),
        to: Pos(cur.line, token.end)
      };
    }else if( prevFolder(editor)){
       // console.log('folder prev');
       var names = getChildrenNames(root, ""); 
       // console.log(names);
       return {
        list: names,
        from: Pos(cur.line, cur.ch),
        to: Pos(cur.line, cur.ch)
      };       
    }else if(cur.line == 0){
      var filter = editor.getLine(cur.line).substring(0, cur.ch);
      var res = filterArr(types, filter);
      return {
        list: res,
        from: Pos(cur.line, 0),
        to: Pos(cur.line, token.end)
      }; 
    }else if(cur.line == 1 && !token.type){
      var filter = editor.getLine(cur.line).substring(0, cur.ch);
      return {
        list: ['folder'],
        from: Pos(cur.line, 0),
        to: Pos(cur.line, cur.ch)
      }; 
    }
    else{
      return null;
    }

  };

  
})();
