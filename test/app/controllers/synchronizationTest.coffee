assert = require 'assert'

appControllerFn = require '../../../app/controllers/app'
transactionModel = require '../../../app/models/transaction'

config = require('cson-config').load __dirname + '/../../../app/config.cson'
jwtHelper = require('../../../app/util/jwtHelper') config.jwt
protoBufHelper = require('../../../app/util/protoBufHelper') 'AccountDelta', __dirname + "/../../../app/accountDelta.proto"


mockTransaction = {guid: "giud"}
emptyRequest = {
	user: ui: 1234
	body:
		accountDelta:
			addedOrModified: [mockTransaction]
}


# request = {
# 	user: ui: 1234
# 	body:
# 		accountDelta:
# 			addedOrModified: [mockTransaction]
# 			serverTimestamp: new Date().getTime()
# }

mockPgClient = (err, res) -> {
	upsert: (sql, data, where, params, done) ->
		process.nextTick ->
			done err, res

	queryAll: (sql, params, done) ->
		process.nextTick ->
			done err, res
}

createAppController = (err, res) ->
	appControllerFn null, transactionModel(mockPgClient(err, res)), jwtHelper, protoBufHelper


describe '#Sync controller', ->
	@timeout 100

	it 'should synchronize data', (done) ->
		controller = createAppController null, [mockTransaction]
		res = {
			send: (accountDelta) ->
				accountDelta = protoBufHelper.decode accountDelta
				transaction = accountDelta.addedOrModified.pop()
				assert.equal true, transaction.guid is mockTransaction.guid, 'Transaction guid didn\'t match with origin guid'
				done()
		}

		controller.sync emptyRequest, res, null

	## TODO write tests to test database errors
