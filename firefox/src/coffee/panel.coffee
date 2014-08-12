panel = new Port self.port, {
  init: ({name, url})->
    $("page-name").innerHTML = name
    $("page-url").innerHTML = url
}
