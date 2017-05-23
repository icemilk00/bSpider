#coding:utf-8
import requests
import re
import json
import sys
import time

baseUrl = 'http://www.aizhufu.cn/duanxinku/column/'
beginUrl = 'http://www.aizhufu.cn/duanxinku/column/77_1/1.html'

category_id = 0
page_num = 0

def makeCurrentWebPageUrl(categoryId, pageNum):
	return baseUrl + str(categoryId) + '/' + str(pageNum) + '.html'

def readCategoryList():
	print(sys.path[0])
	f = open(sys.path[0] + '/data.json', 'r')
	try:
		category_jsonstr = f.read()
	except:
		print('读取文件出错')
	finally:
		f.close()

	jsonArray = json.loads(category_jsonstr)
	return jsonArray

def parseWeb(categoryName,categoryId):

	print(categoryName, categoryId)

	parseIndex = 0

	while True:
		parseIndex += 1
		needParseUrl = makeCurrentWebPageUrl(categoryId, parseIndex)
		print(needParseUrl)
		try:
			r = requests.get(needParseUrl)
		except:
			print('打开连接错误 --->' + needParseUrl)
			continue

		r.encoding = 'utf-8'

		if 'html' not in r.headers['content-type']:
			continue

		if r.status_code == 404:
			print('链接找不到 --->' + needParseUrl)
			continue

		try: 
			data = r.text
		except:
			continue

		if len(data) <= 0:
			print('没有数据 --->' + url)
			return True

		linkForData = re.compile(r'<meta http-equiv="Content-Type".*?<title>(.*?)</title>', re.S)
		result = linkForData.findall(data)
		if '404' in result[0]:
			print('页面没找到')
			return True

		linkre = re.compile(r'<span.*?columnId="%s".*?columnName="%s".*?>(.*?)</span>.*?readContent".*?>(.*?)</span>' % (categoryId, categoryName), re.S)
		for index,result in enumerate(linkre.findall(data)):
			dataDict = dict()
			# print(result[0], result[1])
			dataDict['id'] = result[0]
			dataDict['category_name'] = categoryName
			dataDict['category_id'] = categoryId
			dataDict['content'] =  result[1]
			dataDict['created_at'] = time.time()

			sms_dataArray.append(dataDict)


key0 = 'categoryValue'
key1 = 'categoryName'

sms_dataArray = list()

def parseJsonData(dataArray):
	for obj in dataArray:
		value = obj[key0]
		if isinstance(value, str):
			print('isStr:' + obj[key1])
			parseWeb(obj[key1] , value)
		elif isinstance(value, list):
			print('isArray:' + obj[key1])
			parseJsonData(value)

	return


categoryArray = readCategoryList()

try:
	parseJsonData(categoryArray)
finally:
	jsonstr = json.dumps(sms_dataArray)
	f = open(sys.path[0] + '/sms_data.json', 'w')
	try:
		f.write(jsonstr)
	finally:
		f.close()



