import re, time, json, logging, hashlib, base64, asyncio, sys 

from coroweb import get, post
from aiohttp import web

from models import Sms, next_id

from config import configs

from apis import Page, APIValueError, APIResourceNotFoundError,APIError
import markdown2
logging.basicConfig(level=logging.DEBUG)

#获取页数，主要是做一些容错处理
def get_page_index(page_str):
	p = 1
	try:
		p = int(page_str)
	except ValueError as e:
		pass
	if p < 1:
		p = 1
	return p

#获取所有分类信息的数组
def readCategoryList():
	print(sys.path[0])
	f = open(sys.path[0] + '/dataSource/data.json', 'r')
	try:
		category_jsonstr = f.read()
	except:
		print('读取文件出错')
	finally:
		f.close()

	jsonArray = json.loads(category_jsonstr)
	jsonArray.insert(0, {"categoryValue": "0", "categoryName": "今日推荐"})
	return jsonArray

#获取categoryID的短信信息，如果categoryId为空默认拉出推荐id的信息
@get('/api/action=1')
def api_get_sms_list(*, categoryId = None, page='1'):

	print(categoryId)
	if categoryId is None or categoryId is '0':
		categoryId = configs.categoryId

	print(categoryId)
	if int(page) < 1:
		page = '1'

	page_index = get_page_index(page)
	beginIndex = (page_index-1) * 20
	rows = 20

	print(categoryId)
	sms = yield from Sms.findAll(where= 'category_id = ' + str(categoryId) ,orderBy='id asc', limit=(beginIndex, rows))

	retCode = 1000
	if sms is None:
		retCode = 1001

	return dict(retCode=retCode, sms=sms)


#获取所有分类信息
@get('/api/action=2')
def api_category_conf():

	categoryArray = readCategoryList()

	retCode = 1000
	if categoryArray is None:
		retCode = 1001

	return dict(retCode=retCode, categoryArray=categoryArray)



#获取默认配置信息
@get('/api/action=10000')
def api_client_conf(request):
	# print('request head = %s' % request.headers)
	clientVersion = request.headers['c_version']
	reviewVersion = configs.client_review_version;

	clientCf = configs.clientConfigs

	if clientVersion == reviewVersion:
		clientCf = configs.review_clientConfigs
		
	# print('clientcf = %s' % clientCf)
	return dict(retCode=1000, clientConfigs=clientCf)


#反馈接口 - 未完成
@post('/api/action=20000')
def api_feedback(request, *, feedContent, feedTime):
	#print('request head = %s' % request.headers)
	return dict(retCode=1000)
	

