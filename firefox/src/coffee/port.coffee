class Port
  constructor: (portObject, methods)->
    for name, method of methods
      portObject.on(name, method)
    @methods = methods

  wrapper: () ->
    res = {}
    for name, method of @methods
      res[name] = (args) -> portObject.port.emit(name, args)
    res
exports.Port = Port
