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
	'categoryId':'121',	

	'client_review_version': '3.0.0.1',		#审核版本，过审后设置为飞使用版本的版本号

	'clientConfigs':{
		'recommendCf':{
			'recommendItemCanClicked': True,	#是否可进详情页
			'homeRecommendID': 5580797,			#首页的推荐库id，即分类id为0
			'defaultRecommendID': 5761142		#默认的推荐库id （非定向关联分类的推荐库）
		},
		'activityCf':{
			'showActive': True,					#是否显示活动按钮
			'activityStr': '复制这段文字，打开支付宝，最高188红包立马送，Ti28Sc10cB',		#活动字符
		},
	},

	'review_clientConfigs':{
		'recommendCf':{
			'recommendItemCanClicked': False,
			'homeRecommendID': 5580797,
			'defaultRecommendID': 5761142
		}
	}




}