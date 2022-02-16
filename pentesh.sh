echo "Updating nuclei templates............"
nuclei --update-templates

echo "Updatations is completed................................"

read -p "Enter domain names seperated by 'space' : " input
for i in ${input[@]}
do
echo "Scan star for $i"
echo "$i Directery creating... "
mkdir $i
mkdir -p ./output/$i

python3 /toools/Sublist3r/sublist3r.py -d $i -o ./output/$i/sublister.txt
amass enum -d $i -o ./output/$i/amass.txt --passive
assetfinder -subs-only $i | tee ./output/$i/assetfinder.txt
subfinder -d $i | tee ./output/$i/subfinder.txt

cat ./output/$i/* >> ./output/$i/allhost.txt

cat ./output/$i/allhost.txt | anew | tee ./output/$i/host.txt
cat ./output/$i/host.txt | httprobe > ./output/$i/subdomains.txt
cp ./output/$i/subdomains.txt ./$i/subdomains.txt -r

echo "Subdomains are saved at ./$i/subdomains.txt"
echo "====================--Subdomain Scaning Done--================================"

echo "Scan for CVES started..."
nuclei -l $i/subdomains.txt -t cves/ -o $i/cves.txt

echo "Scan for default-logins started ... "
nuclei -l $i/subdomains.txt -t default-logins/ -o $i/logins.txt

echo "Scan for exposed-panels started ...."
nuclei -l $i/subdomains.txt -t exposed-panels/ -o $i/exposed-panels.txt

echo "Scan for DNS  started....."
nuclei -l $i/subdomains.txt -t dns/ -o $i/dns.txt 

echo "Scan for cnvd  started....."
nuclei -l $i/subdomains.txt -t cnvd/ -o $i/cnvd.txt 

echo "Scan for exposures started....."
nuclei -l $i/subdomains.txt -t exposures/ -o $i/exposures.txt

echo "Scan for files  started....."
nuclei -l $i/subdomains.txt -t file/ -o $i/file.txt

echo "Scan for headless started....."
nuclei -l $i/subdomains.txt -t headless/ -o $i/headless.txt

echo "Scan for iot  started....."
nuclei -l $i/subdomains.txt -t iot/ -o $i/iot.txt

echo "Scan for miscellaneous started....."
nuclei -l $i/subdomains.txt -t miscellaneous/ -o $i/miscellaneous.txt

echo "Scan for misconfiguration started....."
nuclei -l $i/subdomains.txt -t misconfiguration/ -o $i/misconfiguration.txt

echo "Scan for Newtork  started....."
nuclei -l $i/subdomains.txt -t network/ -o $i/network.txt

echo "Scan for SSL started ..."
#nuclei -l $i/subdomains.txt -t ssl/ -o $i/ssl.txt

echo "Scan for Takeover started ..."
nuclei -l $i/subdomains.txt -t takeovers/ -o $i/takeovers.txt

echo "Scan for Technologies started ..."
nuclei -l $i/subdomains.txt -t technologies/ -o $i/technologies.txt

echo "Scan for Token-spray started ..."
nuclei -l $i/subdomains.txt -t token-spray/ -o $i/token-spray.txt

echo "Scan for vulnerabilities started ..."
nuclei -l $i/subdomains.txt -t vulnerabilities/ -o $i/vulnerabilities.txt

done

echo "=========================---Finish---======================="
echo "Scaning Done."

