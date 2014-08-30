{Request} = require "sdk/request"
describe = (e)->
  for name, value of e
    console.log "#{name}: #{value}"

class ApiRequest
  apiRoot = "http://127.0.0.1:8080/api"
  constructor: ({@method, @params}) ->
    @request = Request({
        content: JSON.stringify @params
        contentType: "application/json"
        url: "#{apiRoot}/#{@method}"
        onComplete: (responce) =>
          console.log "onComplete: res #{responce.status}"
          if responce.status != 200
            @error responce if @error?
          else
            responce = responce.json
            throw new Error "Api error: #{responce.message}" if responce.status != "ok"
            @success responce if @success?
      })

  # abstract
  _processRequest: (request)-> throw new Error("Must override processRequest")

  execute: ({@success, @error})->
    @_processRequest @request

class GetApiRequest extends ApiRequest
  _processRequest: (request) -> request.get()

class PostApiRequest extends ApiRequest
  _processRequest: (request) -> request.post()

class AddLinkRequest extends PostApiRequest
  constructor: ({name, url, tags, description})->
    super
      method: "addLink"
      params: {name, url, tags, description}



exports.addLink = ({name, url, description, tags})-> (new AddLinkRequest {name, url, description, tags})
