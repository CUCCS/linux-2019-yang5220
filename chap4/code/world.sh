#!/usr/bin/env bash
function read_file(){
  i=0
  col=1
  while read -r line; do
    if [ $col -eq 1 ];then
      col=0
    else
      str=(${line[@]// /*})
      group_line[$i]=${str[0]}
      country_line[$i]=${str[1]}
      rank_line[$i]=${str[2]}
      jersey_line[$i]=${str[3]}
      position_line[$i]=${str[4]}
      age_line[$i]=${str[5]}
      select_line[$i]=${str[6]}
      club_line[$i]=${str[7]}
      player_line[$i]=${str[8]}
      captain_line[$i]=${str[9]}
      i=$(($i+1))
    fi
  done < worldcup.tsv
  all=$i

}
# age_range
function age_range(){
  echo -e "\nage range:"
  # 统计年龄范围
  less_20=0
  btw_20_30=0
  greater_30=0
  for i in ${age_line[@]}; do
    if  [ "$i"!="Age" ] ;then
      if  [ $i -lt 20 ] ;then
        less_20=$(($less_20+1))
      elif  [ $i -gt 30 ] ;then
        greater_30=$(($greater_30+1))
      elif  [ $i -ge 20 ] &&  [ $i -le 30 ] ;then
        btw_20_30=$(($btw_20_30+1))
      fi
    fi
  done

  percent_20=$(bc<<<"scale=3; $less_20/$all*100")

  percent_20_30=$(bc<<<"scale=3; $btw_20_30/$all*100")
  
  percent_30=$(bc<<<"scale=3; $greater_30/$all*100")

  echo Therer are $less_20 players age less than 20, percent $percent_20 
  echo There are $btw_20_30 palyers age between 20 and 30, percent $percent_20_30
  echo Therer are $greater_30 players abe greater 30, percent $percent_30
  echo The total number is $all
 # echo ${#age_line[@]}
 
}

function position(){
  # 统计场上不同位置的球员数量、百分比
  echo -e "\nposition:"
  Goalie=0
  Midfielder=0
  Forward=0
  Defender=0
  for ele in ${position_line[@]} ;do

    if [ $ele == "Goalie" ] ;then
      Goalie=$(($Goalie+1))
    elif [ "$ele" == "Midfielder" ] ;then
      Midfielder=$(($Midfielder+1))
    elif [ "$ele" == "Forward" ] ;then
      Forward=$(($Forward+1))
    elif [ "$ele" == "Defender" ] ;then
      Defender=$(($Defender+1))
    else
      echo $ele
    fi
  done


  percent_Goalie=$(bc<<<"scale=3; $Goalie/$all*100")

  percent_Mid=$(bc<<<"scale=3; $Midfielder/$all*100")

  percent_Forward=$(bc<<<"scale=3; $Forward/$all*100")
   
  percent_Def=$(bc<<<"scale=3; $Defender/$all*100")

  echo There are  $Goalie Goalie and percet is $percent_Goalie
  echo There are $Midfielder Midfielder  and percent is $percent_Mid
  echo There are $Forward Forward and percent is $percent_Forward
  echo There are $Defender Defender and percent is $percent_Def 
 

}

function max_min_age(){
  # 年龄最大、最小的运动员
  echo -e "\noldest and youngest player:"
count=0
max=0
min=100
max_index=0
min_index=0

for ele in ${age_line[@]} ;do
  if [ $ele -lt $min ];then
    min=$ele
    min_index=$count
  fi 
  if [ $ele -gt $max ];then
    max=$ele
    max_index=$count   
  fi
  count=$(($count+1))
done
echo ${player_line[$max_index]} is the oldest player,his age is $max
echo ${player_line[$min_index]} is the youngest player,his age is $min 
#echo $count
}

 function long_short_name(){
 # 名字最长、最短的运动员
 echo -e "\nlongest name and shortest name player:"
   max_length=0
   min_length=100

   for ele in ${player_line[@]};do
     if [ ${#ele} -gt $max_length ];then
      max_length=${#ele}
      max_name=$ele 
     fi
     if [ ${#ele} -lt $min_length ];then
       min_length=${#ele}
       min_name=$ele
     fi
   done

   echo The longest name is $max_name
   echo The shortest name is $min_name


 }

 #function use(){
#echo "-a     统计不同年龄区间范围的球员数量、百分比"
#echo "-p     统计不同场上位置的球员数量、百分比"
#echo "-n     名字最长、最短的运动员"
#echo "-m     年龄最大、最小的运动员"
#echo "-h     帮助文档"

# }

read_file
age_range
position
long_short_name
max_min_age



 #if [ "$#" -lt 1 ];then
 #  echo "need more parameters"
 #  exit
# else
 #  case "$1" in 
 #    -a) age_range ;;
 #    -p) position ;;
   #  -n) long_short_name ;;
   #  -m) max_min_age ;;
  #   -h) use ;;
 #  esac
# fi




