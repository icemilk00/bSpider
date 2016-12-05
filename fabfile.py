import os, re
from datetime import datetime

from fabric.api import *

env.user = 'root'
env.sudo_user = 'root'
env.hosts = ['121.42.29.56']

db_user = 'www-data'
db_password = 'www-data'

