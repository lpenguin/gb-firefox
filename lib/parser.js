// parser.js - lpenguin's module
// author: lpenguin

function merge(obj1, obj2){
    for(var key in obj2){
        obj1[key] = obj2[key];
    }
    return obj1;
}


var parserClass = function(params){
    this.url = params.url;
    this.title = params.title;
    
    var folderRe = /(folder)\s*/;
    var todoRe = /(todo)/;
    var bookmarkRe = /(bookmark)/;
    var noteRe = /(note)\s*/;
    var tagRe = /(tag)\s*/;

    this.parseLine = function(line, command){
        if(line.match(bookmarkRe)){
            command.type = 'bookmark';
        }else if(line.match(todoRe)){
            command.type = 'todo';
            command.text += line.replace(todoRe, '');
        }else if(line.match(folderRe)){
            command.folders.push(line.replace(folderRe, ''));
        }else if(line.match(tagRe)){
            command.tags.push(line.replace(tagRe, ''));
        }else if(line.match(noteRe)){
            command.type = 'note';
            command.name = line.replace(noteRe, '');
        }else{
            command.text += line + "\n";
        }
        return command;
    }
    this.parse = function(text, params){
        var command = {
            url: this.url(),
            title: this.title(),
            text: "",
            folders: [],
            tags: []
        }
        var lines = text.split('\n');
        for(var i in lines){
            var line = lines[i];
            command = this.parseLine(line, command);
        }
    
        
        return this.validate(command);
    }
    
    this.validate = function(command){
        if(command.type == 'todo'){
            if(!command.text){
                command.error = 'todo without text';
            }
        }
        return command;
    }
};

var Parser = function(params){
    return new parserClass(params);
}
exports.Parser = Parser;

