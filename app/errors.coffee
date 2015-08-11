util = require 'util'

BadCredentials = ->
	Error.captureStackTrace this, this.constructor

	this.type = 'Login'
	this.message = 'Bad Credentials'
	this.resCode = 401

util.inherits BadCredentials, Error

UserNotFound = ->
	Error.captureStackTrace this, this.constructor

	this.type ='Login'
	this.message = 'User not found'
	this.resCode = 401


util.inherits UserNotFound, Error

TokenValidation = (err) ->
	err ?= this
	Error.captureStackTrace err, this.constructor

	this.type ='Authentication'
	this.message = 'Token isn\'t valid'
	this.resCode = 401
	Error.captureStackTrace this, BadCredentials

util.inherits TokenValidation, Error

ProtoBuffersConvert = (message) ->
	Error.captureStackTrace this, this.constructor

	this.type ='ProtoBuffers'
	this.message = message || 'Cannot convert proto buffers message'
	this.resCode = 401

util.inherits ProtoBuffersConvert, Error

module.exports = {
	BadCredentials
	UserNotFound
	TokenValidation
	ProtoBuffersConvert
}