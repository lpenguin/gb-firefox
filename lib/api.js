var Request = require("sdk/request").Request;

var api_url = "http://lilacpenguin.me:4567/api";


function apiCall(method, data, callback, errorCallback){
  // if(callback == undefined){
  //   callback = data;
  //   data = undefined;
  // }

  var url = api_url + '/' + method.replace('.', '/')+'/';
  console.log("sendind url "+ url);
  var content = undefined;
  if(data){
    content = { data: data };
    console.log('content.data: '+content.data);

  }
    
  
  console.log('errorCallback: '+errorCallback)
  var request = Request({
      url: url,
      content: content,
      onComplete: function (response) {
        console.log("Got response, status: "+response.status)
        if(response.status != 200){
          return errorCallback(response);
        }
        if(callback)
          callback(response);
      }
  });

  if(data)
    request.post();
  else
    request.get();
}

function getFolders(callback, errorCallback){
    apiCall('folders.get', null, function(response){
      if(callback)
        callback(response.json);
    }, errorCallback);
}

function sendNode(node, callback, errorCallback){
    var data = JSON.stringify(node);
    apiCall('node.add', data, function(response){
      if(callback)
        callback();
    }, errorCallback);
}

function setApiUrl(url){
  console.log("setting api_url: "+url);
  api_url = url;
}

exports.api = {
  sendNode: sendNode,
  getFolders: getFolders,
  apiCall: apiCall,
  setApiUrl: setApiUrl

};