RED='\033[0;31m'
NC='\033[0m' # No Color
printf "${RED}AutoScanner${NC}\n"

echo "domain: "$1; 

mkdir subdomain
mkdir tmp
mkdir exploit

#Amass_Active
#echo "amass enum -active -log amass.log -r 8.8.8.8,1.1.1.1 -brute -w MyWordlist/subdomainwordlist.txt -config MyWordlist/config.ini -dir amass/active/$1 -o amass_active_$1.txt -d $1\n"
#amass enum -active -log subdomain/amass/amass.log -r 8.8.8.8,1.1.1.1 -brute -w MyWordlist/subdomains-top1million-110000.txt -config MyWordlist/config.ini -dir subdomain/amass/active/$1 -o tmp/amass_active_$1.txt -d $1

#Amass_Active
printf "${RED}amass enum -passive -r 8.8.8.8,1.1.1.1 -log amass.log -config MyWordlist/config.ini -dir amass/passive/$1 -o  amass_passive_$1.txt -d $1${NC}\n"
amass enum -passive -r 8.8.8.8,1.1.1.1 -log subdomain/amass/amass.log -config MyWordlist/config.ini -dir subdomain/amass/$1 -o tmp/amass_passive_$1.txt -d $1

#Subfinder
echo "subfinder -d $1 -all -o subfinder/subfinder_$1.txt"
subfinder -d $1 -all -o tmp/subfinder_$1.txt

#sublist3r
echo "sublist3r -d $1 -o sublister/sublister_$1.txt"
sublist3r -d $1 -o tmp/sublister_$1.txt

#findomain-linux
echo "findomain-linux -t $1 -o"
findomain-linux -t $1 -o
mv $1.txt tmp/

#crtsh_enum_web.py
echo "python3 Scripts/crtsh_enum_web.py $1 | tee -a crtshweb_$1.txt"
python3 Scripts/crtsh_enum_web.py $1 | tee -a tmp/crtshweb_$1.txt

#crtsh_enum_psql.sh
echo "Scripts/crtsh_enum_psql.sh  $1 | tee -a crtshpsql_$1.txt"
Scripts/crtsh_enum_psql.sh  $1 | tee -a tmp/crtshpsql_$1.txt

#ctfr.py
echo "python3 Scripts/ctfr/ctfr.py -d $1 -o ctfr_$1.txt"
python3 Scripts/ctfr/ctfr.py -d $1 -o tmp/ctfr_$1.txt

#dnscan.py
#echo "python3 Scripts/dnscan/dnscan.py -d $1 -w Scripts/dnscan/subdomains-10000.txt -r -a -R 8.8.8.8 -q -o dnscan_$1.txt"
#python3 Scripts/dnscan/dnscan.py -d $1 -w Scripts/dnscan/subdomains-10000.txt -r -a -R 8.8.8.8 -q -o dnscan_$1.txt
#python3 Scripts/dnscan/dnscan.py -d $1 -w Scripts/dnscan/subdomains-10000.txt -R 8.8.8.8,1.1.1.1 -n -q -t 120 -q -o tmp/dnscan_$1.txt

#Github_Subdomain
echo "Github Subdomain enumerate.."
python3 Scripts/github-search/github-subdomains.py -t ghp_abnEAsfsdfsFmM75vgiDsdsadaXUSfv2W2Jfsdfsdf8z0R -d $1 >>  tmp/Github_Subdomain.txt


#Finding ASN Number and IP Address list for manual port scanning
#printf "${RED}Finding ASN Number and IP Address list for manual port scanning...${NC}\n"
#mkdir exploit/portscan
#mkdir exploit/portscan/nmap
#curl -s "http://ip-api.com/json/paypal.com" | jq -r '.as' >> exploit/portscan/nmap/asn.txt
#var=$(grep -o '^\S*' exploit/portscan/nmap/asn.txt)
#echo "$var"
#whois -h whois.radb.net -- "-i origin $var" | grep -Eo "([0-9.]+){4}/[0-9]+" | uniq > exploit/portscan/nmap/ASN_IP_$1.txt


#Fingerprinting with Shodan and Nuclei engine
#printf "${RED}Fingerprinting with Shodan and Nuclei engine...${NC}\n"
#mkdir exploit/nuclei
#shodan domain $1 | awk '{print $3}' | httpx -silent | sort -u | tee -a exploit/nuclei/Data_From_Shodan_URL.txt
#cat exploit/nuclei/Data_From_Shodan_URL.txt | tr "/" " " | awk '{print $2}' | tee -a exploit/nuclei/Data_From_Shodan_subdomains.txt
#shodan domain $1 | awk '{print $3}' | httpx -silent | nuclei -t /root/nuclei-templates/ -o exploit/nuclei/Fingerprinting_with_Shodan_Nuclei -interactsh-url https://iplogger.org/1ygAp7.jpg
#cp exploit/nuclei/Data_From_Shodan_subdomains.txt tmp/nuclei/Data_From_Shodan_subdomains.txt

#Get Subdomains from BufferOver.run
curl -s https://dns.bufferover.run/dns?q=.$1 |jq -r .FDNS_A[]|cut -d',' -f2|sort -u | tee -a tmp/BufferOversubdomain.txt

#Get Subdomains from Riddler.io
curl -s "https://riddler.io/search/exportcsv?q=pld:$1" | grep -Po "(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee -a tmp/Riddler.txt

#Get Subdomains from CertSpotter
curl -s "https://certspotter.com/api/v1/issuances?domain=$1&include_subdomains=true&expand=dns_names" | jq .[].dns_names | tr -d '[]"\n ' | tr ',' '\n' | tee -a tmp/CertSpotter.txt

#Get Subdomains from Archive
curl -s "http://web.archive.org/cdx/search/cdx?url=*.$1/*&output=text&fl=original&collapse=urlkey" | sed -e 's_https*://__' -e "s/\/.*//" | sort -u | tee -a tmp/Archive.txt

#Get Subdomains from JLDC
curl -s "https://jldc.me/anubis/subdomains/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | sort -u | tee -a tmp/jldc.txt

#Get Subdomains from securitytrails
curl -s "https://securitytrails.com/list/apex_domain/$1" | grep -Po "((http|https):\/\/)?(([\w.-]*)\.([\w]*)\.([A-z]))\w+" | grep ".$1" | sort -u | tee -a tmp/securitytrails.txt

#Get Subdomains With sonar.omnisint.io
curl --silent https://sonar.omnisint.io/subdomains/$1 | grep -oE "[a-zA-Z0-9._-]+\.$1" | sort -u | tee -a tmp/sonar.txt

#Subdomain Bruteforcer with FFUF
#ffuf -u https://FUZZ.$1 -w MyWordlist/subdomains-top1million-110000.txt -v | grep "| URL |" | awk '{print $4}' | tr "/" " " | awk '{print $2}' | tee -a tmp/ffufsubdomain.txt



printf "${RED}..........................................Merging_All_Subdomain.................................${NC}\n"
cat tmp/* >> subdomain/tmp_merge_all_passive_$1.txt
cat subdomain/tmp_merge_all_passive_$1.txt | sort -u | tee -a subdomain/merge_all_passive_sort_$1.txt 
rm -f subdomain/tmp_merge_all_passive_$1.txt
rm -f tmp/*



#Final Passive Subdomain FIle Name: subdomain/merge_all_passive_sort_$1.txt

#GoAlt_DNS
#echo "goaltdns"
#goaltdns -l  subdomain/merge_all_passive_sort_$1.txt  -w MyWordlist/altdnswords.txt -o tmp/altdnsout_$1.txt
#cat subdomain/merge_all_passive_sort_$1.txt tmp/altdnsout_$1.txt >> tmp/merge_passive_altdns.txt
#cat tmp/merge_passive_altdns.txt | sort -u | tee -a subdomain/merge__sort_passive_altdns.txt
#rm -f tmp/*

#Copyiing file to tmp for httpx run
mkdir raw_data
FILE=subdomain/merge__sort_passive_altdns.txt
if [ -f "$FILE" ]; then
	echo "$FILE exists."
	cp subdomain/merge__sort_passive_altdns.txt tmp/httpxcheck.txt
	cp subdomain/merge__sort_passive_altdns.txt raw_data/merge__subdomain_raw.txt
else
	echo "$FILE exists."
	cp subdomain/merge_all_passive_sort_$1.txt tmp/httpxcheck.txt
	cp subdomain/merge_all_passive_sort_$1.txt raw_data/merge__subdomain_raw.txt
fi


#HTTPX Start........


echo "Subdomain HTTPX CHecking..."
httpx -l tmp/httpxcheck.txt -probe | tee -a tmp/httpx_check_subdomain_$1.txt
cat tmp/httpx_check_subdomain_$1.txt | grep 'SUCCESS' | awk '{print $1}' | tee -a tmp/httpx_success_URLS_$1.txt
cat tmp/httpx_success_URLS_$1.txt | tr '/' ' '| awk '{print $2}' | tee -a tmp/httpx_success_subdomain_$1.txt

echo "Removing file from subdomain...."
rm -f subdomain/*
cp tmp/httpx_success_URLS_$1.txt subdomain/httpx_success_URLS_$1.txt
cp tmp/httpx_success_subdomain_$1.txt subdomain/httpx_success_subdomain_$1.txt
rm -r tmp/*

printf "1.${RED} Final URLs File: subdomain/httpx_success_URLS_$1.txt${NC}\n"
printf "2.${RED} Final Subdomain File: subdomain/httpx_success_subdomain_$1.txt${NC}\n"


printf "${RED}..........................................Subdomain_Enumeration_Done...............................${NC}\n"


