module.exports = (pgClient) ->
	findUser: (userName, password, done) ->
		pgClient.queryOne "SELECT * FROM user where user_name = $1 and password = $2", [userName, password], done