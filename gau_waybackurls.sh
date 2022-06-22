RED='\033[0;31m'
NC='\033[0m' # No Color
printf " ${RED}AutoScanner_Gau_Waybackurls${NC}\n"

#mkdir waybackurl_gau

printf "1.${RED} Final URLs File: subdomain/httpx_success_URLS_$1.txt${NC}\n"
printf "2.${RED} Final Subdomain File: subdomain/httpx_success_subdomain_$1.txt${NC}\n"

printf "${RED}Gau Scan...${NC}\n"
cat subdomain/httpx_success_URLS_$1.txt | gauplus --random-agent -t 70 -o  tmp/gauplus_output_$1.txt

printf "${RED}Waybackurls Scan...${NC}\n"
cat subdomain/httpx_success_URLS_$1.txt | waybackurls | tee -a tmp/waybackurls_output_$1.txt

#Copying file for future use
cp tmp/waybackurls_output_$1.txt waybackurl_gau/waybackurls_output_$1.txt


#Filtering Waybackurls
printf "${RED}Filtering Waybackurls...${NC}\n"
sed -i "s/^http.*\/$//" tmp/waybackurls_output_$1.txt
sed -i "s/^http.*\/$//" tmp/gauplus_output_$1.txt
grep -vE "robots.txt$|robots.txt\/$|.gif|.jpg|.jpeg|.css|.tiff|.ico|.png|.svg|.ttf|.woff|.woff2|.eot|.pdf" tmp/waybackurls_output_$1.txt  >> tmp/waybackurls_output_clean_$1.txt
grep -vE "robots.txt$|robots.txt\/$|.gif|.jpg|.jpeg|.css|.tiff|.ico|.png|.svg|.ttf|.woff|.woff2|.eot|.pdf" tmp/gauplus_output_$1.txt >> tmp/gauplus_output_clean_$1.txt

#Merging Waybackurls and Gau...
printf "${RED}Merging Waybackurls and Gau...${NC}\n"
cat tmp/waybackurls_output_clean_$1.txt tmp/gauplus_output_clean_$1.txt >> tmp/merge_gau_waybackurls_out.txt
sort -u tmp/merge_gau_waybackurls_out.txt >> tmp/clean_merge_gau_waybackurls_out.txt
cp tmp/clean_merge_gau_waybackurls_out.txt waybackurl_gau/clean_merge_gau_waybackurls_out.txt

#Doing Some Stuff tmp/clean_merge_gau_waybackurls_out.txt
cat tmp/clean_merge_gau_waybackurls_out.txt | unew -combine >> tmp/tmp_clean_merge_gau_waybackurls_out.txt
cat tmp/tmp_clean_merge_gau_waybackurls_out.txt | grep -a "?" >> tmp/final_clean_merge_gau_waybackurls_out.txt
cat tmp/final_clean_merge_gau_waybackurls_out.txt | wurl -c 400 -s "200,302,301,403" --random-agent -o waybackurl_gau/Final_WaybackGau_$1.txt
rm -f tmp/*

#Extracting subdomains from waybackurls_Gau output waybackurl_gau/Final_WaybackGau_$1.txt
printf "${RED}Extracting subdomains from waybackurls_Gau output waybackurl_gau/Final_WaybackGau_$1.txt${NC}\n"
cat waybackurl_gau/Final_WaybackGau_$1.txt | unfurl --unique domains | tee -a tmp/tmp_extract_subdomain_gau_waybackurls.txt
sort -u  tmp/tmp_extract_subdomain_gau_waybackurls.txt >> tmp/extract_subdomain_gau_waybackurls.txt
httpx -l tmp/extract_subdomain_gau_waybackurls.txt -probe | tee -a tmp/httpx_extract_subdomain_gau_waybackurls.txt
cat tmp/httpx_extract_subdomain_gau_waybackurls.txt | grep "SUCCESS" | awk '{print $1}' | tee -a subdomain/httpx_success_extract_urls_gau_waybackurls.txt
cat tmp/httpx_extract_subdomain_gau_waybackurls.txt | tr '/' ' ' | awk '{print $2}' | tee -a subdomain/httpx_success_extract_subdomains_gau_waybackurls.txt
rm -f tmp/*

#Creating final url and subdomain file after merging older subdomains list and waybackurls_gau list
printf "${RED}Creating final url and subdomain file after merging older subdomains list and waybackurls_gau list${NC}\n"
cat subdomain/httpx_success_extract_urls_gau_waybackurls.txt subdomain/httpx_success_URLS_$1.txt >> tmp/tmp_final_urls.txt
cat subdomain/httpx_success_extract_subdomains_gau_waybackurls.txt subdomain/httpx_success_subdomain_$1.txt >> tmp/tmp_final_subdoamins.txt
sort -u tmp/tmp_final_urls.txt >> subdomain/final_urls.txt
sort -u tmp/tmp_final_subdoamins.txt >> subdomain/final_subdomains.txt

rm -f tmp/*

printf "${RED}File created till now...${NC}\n"
printf "1.${RED} Passive Active URLs File: subdomain/httpx_success_URLS_$1.txt${NC}\n"
printf "2.${RED} passive Active Subdomain File: subdomain/httpx_success_subdomain_$1.txt${NC}\n"
printf "3.${RED} Final merge of 1 and Wayback_Gau URLs: subdomain/final_urls.txt${NC}\n"
printf "4.${RED} Final merge of 1 and Wayback_Gau Subdomains: subdomain/final_subdomains.txt${NC}\n"
printf "5.${RED} Raw Waybackurl File: waybackurl_gau/waybackurls_output_$1.txt${NC}\n"
printf "6.${RED} FIlter waybacks and gau merge file:  waybackurl_gau/Final_WaybackGau_$1.txt${NC}\n"
printf "${RED}...........................................Wayback_And_Gau_Work_Done..............................${NC}\n"
