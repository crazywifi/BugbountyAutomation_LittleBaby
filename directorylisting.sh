#Directory Listing...
printf "${RED}Directory Bruteforce..${NC}\n"
mkdir exploit/directory_bruteforce
#ffuf -w MyWordlist/all_all.txt -p "0.1-1.0" -mc 200,302,301,403 -fw 0,1 -recursion -recursion-depth 2 -t 300 -o exploit/directory_bruteforce/ffuf_$1.html -of html -c -v -u /FUZZ
python3 ffufplus.py
