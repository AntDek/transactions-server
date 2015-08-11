protobuf = require 'protocol-buffers'
fs = require 'fs'

module.exports = (key, absPath) ->
	messages = protobuf(fs.readFileSync absPath)

	encode: (payload) ->
		messages[key].encode payload

	decode: (buf) ->
		messages[key].decode buf