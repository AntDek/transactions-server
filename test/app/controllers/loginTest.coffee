assert = require 'assert'

errors = require '../../../app/errors'
appControllerFn = require '../../../app/controllers/app'
userModel = require '../../../app/models/user'

config = require('cson-config').load __dirname + '/../../../app/config.cson'
jwtHelper = require('../../../app/util/jwtHelper') config.jwt


mockUser = {
	id: 12345
}

emptyRequestBody = {
	body:
		userName: null
		password: null
}

requestBody = {
	body:
		userName: 'userName'
		password: 'password'
}

mockPgClient = (err, res) -> {
	queryOne: (sql, params, done) ->
		process.nextTick ->
			done err, res
}

createAppController = (err, res) ->
	appControllerFn userModel(mockPgClient(err, res)), null, jwtHelper, null


describe '#Login controller', ->
	@timeout 100

	it 'should return jwt token after successfull login', (done) ->
		controller = createAppController null, mockUser
		res = {
			json: (token) ->
				user = jwtHelper.decode(token.token)
				assert.equal true, user.id is mockUser.ui, 'User id didn\'t match with origin id'
				done()
		}

		controller.login requestBody, res, null

	it 'should retrun BadCredentials error if userName or password isn\'t set', (done) ->
		controller = createAppController null, mockUser
		next = (err) ->
			assert.equal true, err instanceof errors.BadCredentials, 'Error isn\'t instance of errors.BadCredentials'
			done()

		controller.login emptyRequestBody, {}, next

	it 'should retrun UserNotFound error if user isn\'t found', (done) ->
		controller = createAppController null, null
		next = (err) ->
			assert.equal true, err instanceof errors.UserNotFound, 'Error isn\'t instance of errors.UserNotFound'
			done()

		controller.login requestBody, {}, next