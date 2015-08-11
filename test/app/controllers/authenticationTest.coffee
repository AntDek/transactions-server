assert = require 'assert'

config = require('cson-config').load __dirname + '/../../../app/config.cson'
jwtHelper = require('../../../app/util/jwtHelper') config.jwt

authentication = require('../../../app/controllers/authentication') jwtHelper
errors = require '../../../app/errors'

describe '#Authentication', ->
	@timeout 100

	date = new Date()
	date.setMonth date.getMonth() + 1

	getTime = (month) ->
		date = new Date()
		date.setMonth date.getMonth() + month
	
	userId = 12345
	mockUser = (time) -> {
		ui: userId
		ex: time
	}

	token = jwtHelper.encode mockUser(getTime(1))
	expiredToken = jwtHelper.encode mockUser(getTime(-1))

	it 'should successfully authenticate user', (done) ->
		authentication.isUserAuthenticated token, (err, user) ->
			return done err if err
			assert.equal true, user.ui is userId, 'User id didn\'t match with origin id'
			done()

	it 'should response TokenValidation error if token isn\'t valid', (done) ->
		authentication.isUserAuthenticated 'not valid token', (err, user) ->
			assert.equal true, err instanceof errors.TokenValidation, 'Error isn\'t instanceof TokenValidation'
			done()

	it 'should response TokenValidation error if token is expired', (done) ->
		authentication.isUserAuthenticated expiredToken, (err, user) ->
			assert.equal true, err instanceof errors.TokenValidation, 'Error isn\'t instanceof TokenValidation'
			done()