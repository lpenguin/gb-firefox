{Request} = require "sdk/request"
describe = (e)->
  for name, value of e
    console.log "#{name}: #{value}"

class ApiRequest
  #apiRoot = require("sdk/simple-prefs").prefs.api_url
  apiRoot = "http://localhost:8080/api"
  console.log "INLINE"
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
  constructor: (link)->
    super
      method: "addLink"
      params: link

class TagsRequest extends GetApiRequest
  constructor: ()->
    super
      method: "tags"
      params: {}


exports.addLink = (link)-> (new AddLinkRequest link)
exports.tags = ()-> (new TagsRequest())
