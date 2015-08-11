module.exports = (pgClient) ->
	findUser: (userName, password, done) ->
		pgClient.queryOne "SELECT * FROM users where user_name = $1 and password = MD5($2)", [userName, password], done