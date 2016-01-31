import os, re
from datetime import datetime

from fabric.api import *

env.user = 'root'
env.sudo_user = 'root'
env.hosts = ['121.42.29.56']

db_user = 'blessingSMS-hp'
db_passowrd = 'blessingSMS-hp'

_TAR_FILE = 'dist-blessingSMS-www.tar.gz'

def build():
	includes = ['*.py', '*.sql', 'dataSource']
	excludes = ['test', '.*', '*.pyc', '*pyo']
	local('rm -f dist/%s' % _TAR_FILE)
	with lcd(os.path.join(os.path.abspath('.'), 'www')):
		cmd = ['tar', '--dereference', '-czvf', '../dist/%s' % _TAR_FILE]
		cmd.extend(['--exclude=\'%s\'' % ex for ex in excludes])
		cmd.extend(includes)
		local(' '.join(cmd))


_REMOTE_TMP_TAR = '/tmp/%s' % _TAR_FILE
_REMOTE_BASE_DIR = '/home/develop/srv/blessingSMS'

def deploy():
	newdir = 'www-%s' % datetime.now().strftime('%y-%m-%d_%H.%M.%S')
	run('rm -f %s' % _REMOTE_TMP_TAR)

	put('dist/%s' % _TAR_FILE, _REMOTE_TMP_TAR)

	with cd(_REMOTE_BASE_DIR):
		sudo('mkdir %s' % newdir)

	with cd('%s/%s' % (_REMOTE_BASE_DIR, newdir)):
		sudo('tar -xzvf %s' % _REMOTE_TMP_TAR)

	with cd(_REMOTE_BASE_DIR):
		sudo('rm -rf www')
		sudo('ln -s %s www' % newdir)
		sudo('chown root:root www')
		sudo('chown -R root:root %s' % newdir)
		sudo('python3.4 www/save_sms.py')

	with settings(warn_only=True):
		sudo('supervisorctl stop blessingSMS')
		sudo('supervisorctl start blessingSMS')
		sudo('/etc/init.d/nginx reload')