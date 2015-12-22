#coding:utf-8
import requests
import re
import json
import sys

def getAllCatgoryInfo(url):

	try:
		r = requests.get(url)
	except:
		print('打开连接错误 --->' + beginUrl)
		return False

	r.encoding = 'utf-8'

	if 'html' not in r.headers['content-type']:
		return False

	try: 
		data = r.text
	except:
		return False

	if len(data) <= 0:
		print('没有数据 --->' + url)
		return True

	dataDict = dict()

	linkre2 = re.compile(r'<li><a.*?columnId="(.*?)".*?href="#">(.*?)</a>(.*?)</li>', re.S)
	for result2 in linkre2.findall(data):
		# print(result2[0], result2[1])
		dataDict[result2[1]] = result2[0]
		if len(result2[2].strip()) > 0:
			subDict = dict()
			linkre3 = re.compile(r'<span>-<a href="#".*?columnId="(.*?)".*?>(.*?)</a', re.S)
			for result3 in linkre3.findall(result2[2]):
				# print(result3[0], result3[1])
				subDict[result3[1]] = result3[0]

			dataDict[result2[1]] = subDict

	print(sys.path[0])
	jsonstr = json.dumps(dataDict)
	f = open(sys.path[0] + '/data.json', 'w')
	try:
		f.write(jsonstr)
	finally:
		f.close()

	print(dataDict)

	return True

beginUrl = 'http://www.aizhufu.cn/duanxinku/column/77_1/1.html'

getAllCatgoryInfo(beginUrl)