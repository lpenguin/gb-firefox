{Request} = require "sdk/request"
describe = (e)->
  for name, value of e
    console.log "#{name}: #{value}"

class ApiRequest
  apiRoot = require("sdk/simple-prefs").prefs.api_url
  console.log "INLINE"
  constructor: ({@method, @params}) ->
    @request = Request({
        content: JSON.stringify @params
        contentType: "application/json"
        url: "#{apiRoot}/api/#{@method}"
        onComplete: (responce) =>
          if responce.status != 200
            @_responceFalied responce
          else
            console.log "apiComplete: #{JSON.stringify responce.json}"
            responce = responce.json
            if not responce or not responce.status? or responce.status != 'ok'
              @_responceFalied responce or 'responce is null'
            else
              @_responceSucceed responce
      })

  # abstract
  _processRequest: (request)-> throw new Error("Must override _processRequest")

  _responceFalied: (responce)->
    @reject responce

  _responceSucceed: (responce)->
    @resolve responce

  execute: ()->
    return new Promise (@resolve, @reject) => @_processRequest @request

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

class FindUrl extends PostApiRequest
  constructor: (url)->
    super
      method: "findUrl"
      params:
        url: url

exports.addLink = (link)-> (new AddLinkRequest link).execute()
exports.tags = ()-> (new TagsRequest()).execute()
exports.findUrl = (url)-> (new FindUrl url).execute()
