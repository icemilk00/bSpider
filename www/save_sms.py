#coding:utf-8
import json
import sys
import time

import orm, asyncio
from models import Sms

def readSmsList():
	f = open(sys.path[0] + '/../sms_data.json', 'r')
	try:
		sms_jsonstr = f.read()
	except:
		print('读取文件出错')
	finally:
		f.close()

	jsonArray = json.loads(sms_jsonstr)
	return jsonArray



def test(loop):
	#创建数据库连接池，用户名：www-data, 密码：www-data ,访问的数据库为：awesome
	#在这之前必须现在mysql里创建好awesome数据库，以及对应的表，否则会显示can't connect
	#可以通过命令行输入：mysql -u root -p <schema.sql ，来执行schema.sql脚本来实现数据库的初始化，schema.sql和本文件在同一目录下
	yield from orm.create_pool(loop = loop, user = 'www-data', password='www-data', db='blessingSMS')

	smsArray = readSmsList()

	if len(smsArray) > 0:
		yield from Sms.clearTable()
	# i = 0

	for obj in smsArray:

		# if i > 10:
		# 	return

		sms = Sms(id = obj['id'], category_name = obj['category_name'], category_id = obj['category_id'], content = obj['content'], created_at = obj['created_at'])
		yield from sms.save()

		# i+=1

#获取runloop
loop = asyncio.get_event_loop()
#在loop下加入test事件，开始运行
loop.run_until_complete(test(loop))
#关闭loop
loop.close()


