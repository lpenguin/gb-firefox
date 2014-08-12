class Port
  constructor: (@portObject, methods)->
    for name, method of methods
      @portObject.on(name, method)
    @methods = methods

  wrapper: (methods) ->
    res = {}
    for name in methods
      res[name] = (args) => @portObject.port.emit(name, args)
    res

if exports?
  exports.Port = Port
else
  window.Port = Port
