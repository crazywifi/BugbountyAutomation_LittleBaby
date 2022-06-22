mkdir exploit
mkdir tmp
mkdir subdomain
mkdir waybackurl_gau
./subdomain.sh $1
./gau_waybackurls.sh $1 
./exploit.sh $1 $2
