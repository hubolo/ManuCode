#!/bin/bash
#get proxy list
declare proxyListFile="proxylist_grab.txt1"
declare tmpFile=`mktemp`
declare url
declare line
declare times
declare ip
declare port
declare i
declare j
declare mod

function quit() {
    rm -f $tmpFile
    exit "$1"
}

echo "get proxy list... please wait..."

if [ -r "$proxyListFile" ]
then
  rm -f $proxyListFile
fi

touch $proxyListFile

for url in  " http://www.youdaili.cn/Daili/guonei/2390.html " \
            " http://www.youdaili.cn/Daili/guonei/2390_2.html" \
            " http://www.youdaili.cn/Daili/guonei/2390_3.html" \
            " http://www.youdaili.cn/Daili/guonei/2390_4.html " \
            " http://www.youdaili.cn/Daili/guonei/2390_5.html" 
do
    if GET "$url" > $tmpFile
    then
        grep -oE '^.*<br />.*$' "$tmpFile" | grep -Eo "([0-9]+)(\.[0-9]+){3}:([0-9]+)" \
        | sort -n | uniq | awk -F: '{ printf("%-15s  %s \n",$1,$2); }' >> $proxyListFile
    else
	exec 1>&2
        echo "error: get proxy list fail! chech the url:$url or the network"
        quit 1
    fi
done

echo "done. total `cat $proxyListFile | wc -l` proxy"

quit 0
#exit
#GET http://www.youdaili.cn/Daili/guonei/2390.html > youdaili.html
#grep -oE '^.*<br />.*$' youdaili.html | grep -Eo '([0-9]+)(\.[0-9]+){3}:([0-9]+)@\w+#\w+ \w+'
#	1.202.15.102:63000@HTTP#北京市 电信
#grep -oE '^.*<br />.*$' youdaili.html | grep -Eo '([0-9]+)(\.[0-9]+){3}:([0-9]+)@\w+#\w+ \w+' | tr ':' '\t' | tr '@' '\t'| tr '#' '\t'| tr ' ' '#'
#	1.202.15.102 63000 HTTP 北京市#电信
