import os
urlsfile="subdomain/final_urls.txt"
fileopen = open(urlsfile,"r")
urls = fileopen.readlines()
for url in urls:
	url = url.rstrip()
	#print (url)
	name = url.replace("://","_")
	#print (name)
	cmd = 'ffuf -w MyWordlist/login_wordlist.txt -p "0.1-1.0" -mc 200,302,301,403 -fw 0,1 -recursion -recursion-depth 2 -t 300 -o exploit/admin_login_page/'+name+'.html -of html -c -v -u '+url+'/FUZZ'
	print (cmd)
	os.system(cmd)
