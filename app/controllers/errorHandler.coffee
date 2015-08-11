module.exports = (err, req, res, next) ->
	console.error err.stack
	
	res.status err.resCode || 500
	res.json {
		error: {
			message: err.message || "Api server is broken"
			type: err.type || "Error"
		}
	}