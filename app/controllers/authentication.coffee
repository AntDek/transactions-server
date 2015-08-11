errors = require '../errors'

module.exports = (jwtHelper) -> {
	isUserAuthenticated: (token, done) ->
		try
			user = jwtHelper.decode token
			return done new errors.TokenValidation() if user.ex < new Date().getTime()
			done null, user
		catch e
			done new errors.TokenValidation(e)
}