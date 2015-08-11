errors = require '../errors'

module.exports = (protoBufHelper) -> {
	decode: (req, res, next) ->
		try
			req.body = protoBufHelper.decode req.body.toString()
			next()
		catch e
			next new errors.ProtoBuffersConvert(e.message)
}