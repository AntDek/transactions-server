module.exports = (err, req, res, next) ->
	console.error err.stack
	
	res.status err.code || 500
	res.json {
		error: {
			message: err.message
			type: err.type
		}
	}