#!/usr/bin/env bash

function top_host_ip(){
more +2 web_log.tsv|awk -F '\t' '/^[0-9]/ {print $1}'|sort|uniq -c|sort -nr|head -n 100
exit 0

}

function top_host(){
more +2  web_log.tsv|awk -F '\t' '/^[A-Za-z]/ {print $1}'|sort|uniq -c|sort -nr|head -n 100
exit 0
}

function top_url(){

more +2  web_log.tsv|awk -F '\t' '// {print $5}'|sort|uniq -c|sort -nr|head -n 100
exit 0

}


function res_code_4(){
  # $1 is the 4xx
  echo $1 
  echo response code
  more +2 web_log.tsv|awk -F '\t' '{print $5,$6}'|grep "$1"|sort|uniq -c|sort -nr|head -n 10

  exit 0
}


function response_code(){

  tims=($(more +2 web_log.tsv|awk -F '\t' '{print $6}'|sort|uniq -c|sort -nr|head -n 10|awk '{print $1}'))

  codes=($( more +2 web_log.tsv|awk -F '\t' '{print $6}'|sort|uniq -c|sort -nr|head -n 10|awk '{print $2}'))
  all=${#tims[@]}
  total=0
  for ele in ${tims[@]};do
    total=$(($total+$ele))
  done

  echo $total
  i=0
  while [ $i -lt $all ];do
    percent[$i]=$(bc<<<"scale=3;${tims[$i]}/$total*100")
    i=$(($i+1))
  done

j=0
while [ $j -lt $all ];do
  echo code: ${codes[$j]}, percent: ${percent[$j]}
  j=$(($j+1))
done
exit 0

}

function special_url(){
# $1 is the special url
more +2 web_log.tsv|grep $1|awk -F '\t' '{print $1}'|sort|uniq -c|sort -nr|head -n 100
exit 0


}


#top_host_ip
#top_host
#top_url
#special_url "$1"
#res_code_4 "$1"
#response_code 
function use(){
  echo "-h              统计访问来源主机TOP 100和分别对应的次数"
  echo "-i              统计访问来源主机TOP 100 IP和分别对应的次数"
  echo "-u              统计最频繁被访问的URL TOP 100"
  echo "-r              统计不同响应状态码的出现次数和对应百分比"
  echo "-r4 [4xx]       统计不同4xx状态码对应的TOP 10 URL和对应出现的次数"
  echo "-su [url]       给定URL输出TOP 100访问来源主机"
  echo "-help           帮助文档"

}

if [ "$#" -lt 1 ];then
  echo "need more parameters"
  exit
else
  case "$1" in 
    -h) top_host ;;

    -i) top_host_ip ;;

    -u) top_url ;;

    -r) response_code ;;

    -r4)
      code=$2
      res_code_4 $code ;;

    -su) 
      url=$2 
      special_url $url ;;

    -help) use ;;

  esac
fi









