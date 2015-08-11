errors = require '../errors'
jwt = require 'jwt-simple'
async = require 'async'

module.exports = (userModel, trModel, jwtHelper, protoBufHelper) ->
	
	createJWT = (user) ->
		date = new Date()
		date.setMonth date.getMonth() + 1

		jwtHelper.encode {
			iss: user.id
			exp: date.getTime()
		}

	createDeltaAccount = (transactions) -> {
		serverTimestamp: new Date().getTime()
		addedOrModified: transactions
	}

	login: (req, res, next) ->
		{userName, password} = req.body
		return next new errors.BadCredentials() if not userName or not password
		
		userModel.findUser userName, password, (err, user) ->
			return next err if err
			return next new errors.UserNotFound() if not user
			
			res.json {token: createJWT user}

	sync: (req, res, next) ->
		accountDelta = req.body
		userId = req.user.iss
		serverTimestamp = accountDelta.serverTimestamp

		async.series [
			(done) ->
				return done() if accountDelta.addedOrModified.length is 0
				trModel.updateTransasctions userId, accountDelta.addedOrModified, done
			(done) ->
				trModel.fetchTransactions serverTimestamp, done
		], (err, data) ->
			return next err if err
			res.set('Content-Type', 'application/octet-stream');
			res.send protoBufHelper.encode(createDeltaAccount data[1])
