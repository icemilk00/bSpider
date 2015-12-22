#coding:utf-8
import requests
import re
import json
import sys

baseUrl = 'http://www.aizhufu.cn/duanxinku/column/'
beginUrl = 'http://www.aizhufu.cn/duanxinku/column/77_1/1.html'

category_id = 0
page_num = 0

def makeCurrentWebPageUrl(categoryId, pageNum):
	return baseUrl + str(categoryId) + '/' + str(pageNum) + '.html'

def readCategoryList():
	f = open(sys.path[0] + '/data.json', 'r')
	try:
		category_jsonstr = f.read()
	except:
		print('读取文件出错')
	finally:
		f.close()

	jsonDict = json.loads(category_jsonstr)
	return jsonDict

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

		dataDict = dict()

		linkre = re.compile(r'<span.*?columnId="%s".*?columnName="%s".*?>(.*?)</span>.*?readContent".*?>(.*?)</span>' % (categoryId, categoryName), re.S)
		for result in linkre.findall(data):
			print(result[0], result[1])



def parseDataDict(dataDict):
	categoryKeys = dataDict.keys()
	for key in categoryKeys:
		value = dataDict[key]
		if isinstance(value, str):
			print('isStr:' + key)
			parseWeb(key , value)
		elif isinstance(value, dict):
			print('isdict:' + key)
			parseDataDict(value)


categoryDict = readCategoryList()
parseDataDict(categoryDict)

