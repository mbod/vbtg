import time
import os
import sys

#os.chdir(os.path.dirname(__file__))

#sys.path.append('.')

import bottle
from bottle import get, post, response,request, run, route, template, static_file

female_names = "Erin, Ashley, Paige, Emily, Kristen, Nikki, Becky, Melissa, Hannah, Tracy".split(", ")
male_names = "Joe, Justin, Will, Matt, Steve, Frank, Jason, Craig, Josh, Dave".split(", ")


# ft value
# 0.5 = unfair
# 0 = fair

# cnum
# 1 = female fair
# 2 = female unfair
# 3 = male fair
# 4 = male unfair


@route('/')
def index():
	pID = request.query.pID
        cnum = int(request.query.cnum)
	return template('index', pID=pID, cnum=cnum)


@route('/lobby')
def task():
	pID = request.query.pID
	cnum = int(request.query.cnum)
	taskID = 'vbtg'

	if cnum in (1,2):
		pnames = female_names
	else:
		pnames = male_names

	return template('vbtg', cnum=cnum, pID=pID, pnames=pnames)




@route('/<filename:re:.*\.(js|css|jpg|png|bmp|gif)>')
def static(filename):
	#if filename[-4:] in ('.jpg','.png'):
	#	task+='/img'

	return static_file(filename, root='.')




@route('/log', method="POST")
def write_log():

	try:
		data=json.loads(request.body.read())
		log_file = check_unique("%s_%s" % (data['taskID'],data['pID']))
		log = open('logs/%s.txt' % log_file, 'w')
		log.write(json.dumps(data))
		log.close()
		return 'OK'

	except:
		response.status = 500;
		return "<div>ERROR WRITING RESPONSES</div>"


def check_unique(fname,suffix=1):
	fname_new=fname
	while (os.path.exists('logs/%s.txt' % fname_new)):
		fname_new = '%s_%i' % (fname,suffix)
		suffix+=1
	return fname_new




#application = bottle.default_app()

run(port=1122)
