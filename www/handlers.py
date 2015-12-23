import re, time, json, logging, hashlib, base64, asyncio

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

@get('/api/sms')
def api_get_sms_list(*, categoryId, page='1'):
	page_index = get_page_index(page)
	beginIndex = (page_index-1) * 20
	rows = 20

	sms = yield from Sms.findAll(where= 'category_id = ' + categoryId ,orderBy='id asc', limit=(beginIndex, rows))

	return dict(sms=sms)