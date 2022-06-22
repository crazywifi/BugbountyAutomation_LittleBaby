#WebScreenshot
printf "${RED}WebScreenShot...${NC}\n"
mkdir exploit/webscreenshot
eyewitness --web -x subdomain/final_urls.txt --no-prompt --no-dns --threads 70 -d exploit/webscreenshot/
