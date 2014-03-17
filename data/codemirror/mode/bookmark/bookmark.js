// Quick and dirty spec file highlighting

CodeMirror.defineMode("bookmark", function() {
    var folder = /^(folder)/;
    var keywords = /^(bookmark|note|todo)/;
    var variable = /^([_A-Za-z0-9\.]+)/;
    //var empty = /^\s*$/;

  return {
    startState: function () {
        return {
          folder: false,
          havepath: false
        };
    },
    token: function (stream, state) {
      // stream.eatSpace();
      if (stream.sol() && stream.string.substring(stream.start).match(folder)){ 
        state.folder = true; 
      }

      if (stream.sol() && stream.match(keywords)) { return "def"; }
      if (stream.sol() && stream.match(folder)) { return "comment"; }
      if (state.folder && !state.havepath && stream.match(variable)) { 
        state.folder = false; 
        state.havepath = true;
        return "variable"; 
      }
 
      //if (state.folder && stream.match(empty)) { 
        //state.folder = false; 
        //return "variable"; 
      //}
      
     
      stream.next();
      return null;
    }
  };
});

CodeMirror.defineMIME("text/x-bookmark-lp123", "bookmark");
