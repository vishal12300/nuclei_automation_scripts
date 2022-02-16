echo "======================================================="
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
echo "Scan for log4j started...."
nuclei -l $i/subdomains.txt -t log4j/ -o $i/log4j.txt
echo "Done $i ....."
done
echo "=========================---Finish---======================="
echo "Scaning Done."
