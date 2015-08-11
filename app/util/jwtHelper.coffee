jwt = require 'jwt-simple'

module.exports = (jwtConfig) ->
	{secret, algorithm} = jwtConfig

	encode: (payload) ->
		jwt.encode payload, secret, algorithm

	decode: (token) ->
		jwt.decode token, secret, false, algorithm