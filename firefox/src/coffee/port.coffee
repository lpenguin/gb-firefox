toType = (obj) -> ({}).toString.call(obj).match(/\s([a-zA-Z]+)/)[1].toLowerCase()


class Port
  constructor: (@portObject, @wrapperMethods, @methods)->
    # console.log "creating Port"
    # console.log "port: #{toType(@portObject)}."
    for name, method of @methods
      # console.log " adding event method: #{name} -> #{method}"
      @portObject.on name, method
    # console.log "wrapper"

    port = @portObject

    for name in @wrapperMethods
      # console.log " adding wrapper method: #{name}"
      this[name] = (args) => port.emit(name, args)

if exports?
  exports.Port = Port
else
  window.Port = Port
