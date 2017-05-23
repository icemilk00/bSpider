#默认配置文件
configs = {
	'debug' : True,
	'db' : {
		'host' : '127.0.0.1',
		'port' : 3306,
		# 'user' : 'blessingSMS-hp',
		# 'password' : 'blessingSMS-hp',
		'user' : 'root',
		'password' : 'root',
		'db' : 'blessingSMS'
	},
	'session' :{
		'secret' : 'blessingSMS'
	},

	#默认拉取的categoryid
	'categoryId':'121'	

}