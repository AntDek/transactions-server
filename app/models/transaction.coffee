async = require 'async'

module.exports = (pgClient) ->
	updateTransasctions: (userId, transactions, done) ->
		async.eachLimit transactions, 5, (transaction, next) ->
			transaction.user_id = userId
			pgClient.upsert "transactions", transaction, "guid = $1", [transaction.guid], next
		, done

	fetchTransactions: (updatedTime, done) ->
		pgClient.queryAll "SELECT guid, date, value, kind, deleted FROM transactions WHERE date > $1", [updatedTime], done