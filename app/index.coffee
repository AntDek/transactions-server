# require dependencies to run application
easypg = require 'easypg'
userModelFn = require './models/user'
transactionModelFn = require './models/transaction'
jwtHelperFn = require './util/jwtHelper'
errorHandler = require './controllers/errorHandler'
appControllerFn = require './controllers/app'
authenticationFn = require './controllers/authentication'
protoBufHelperFn = require './util/protoBufHelper')
protoBuffersFn = require './controllers/protoBuffers'

# load configuration
require('cson-config').load()
config = process.config

# instantiate dependencies
pgClient = easypg config.postgre
userModel = userModelFn pgClient
transactionModel = transactionModelFn pgClient
jwtHelper = jwtHelperFn config.jwt

# configurate app
app = require 'express'
passport = require 'passport'
BearerStrategy = require('passport-http-bearer').Strategy

protoBufHelper = protoBufHelperFn 'AccountDelta', __dirname + "/accountDelta.proto"
protoBuffers = protoBuffersFn protoBufHelper

appController = appControllerFn userModel, transactionModel, jwtHelper
authentication = authenticationFn jwtHelper

passport.use new BearerStrategy {}, authentication.isUserAuthenticated


###
	Endpoint logins user by userName and password.
	New token will return if user is successfully authenticated
###
app.post '/login', appController.login

###
	Endpoint synchronizes user data.
	Last synchronization date and new transactions will return
	if synchronization is successfully done
###
app.post '/sync', \
	passport.authenticate('bearer', { session: false }), \
	protoBuffers.decode, \
	appController.sync


# user custom error handler
app.use errorHandler

app.listen 3001, ->
	console.log "listening at 3001"