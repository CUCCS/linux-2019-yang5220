function quality_reduce_jpeg(){
  # 对jpeg图片进行质量压缩
echo -e "quality compress\n"
  # $1 is the directory
  imgs=($(find "$1" -type f \( -iname \*.jpeg \)))
  for img in "${imgs[@]}";do
    tmp=$img
    file_name=${tmp%%.*}
    tmp=$img
    file_tail=${tmp#*.}
    convert "$img" -quality 80 "$file_name"'_quality.'"$file_tail" 
  done

}

function compress(){
# $1 is the image directory
echo -e "compress image\n"

 imgs=($(find "$1" -type f \( -iname \*.jpeg -o -iname \*.png -o -iname \*.svg \)))
 for img in "${imgs[@]}";do
   tmp=$img
   file_name=${tmp%%.*}
   file_tail=${tmp#*.}
   convert "$img" -resize 200x200 "$file_name"'_compress.'"$file_tail"
 done

}

function water(){
  # 添加水印
  # $1 is the image dir
  echo -e "add watermark\n"

 imgs=($(find "$1" -type f \( -iname \*.jpeg -o -iname \*.png -o -iname \*.jpg -o -iname \*.svg \)))
# num="${#imgs[@]}"
 for img in "${imgs[@]}";do
   tmp=$img
   file_name=${tmp%%.*}
   tmp=$img
   file_tail=${tmp#*.}

   convert "$img" -gravity southeast -fill black -pointsize 20 -draw "text 8,8'cuccs'" "$file_name"'_water.'"$file_tail" 
 done

}

function rename(){
  echo -e "add prefix or suffix\n"

# s1 is the image dir,$2 decide to add perfix or suffix 
 imgs=($(find "$1" -type f \( -iname \*.jpeg -o -iname \*.png -o -iname \*.jpg -o -iname \*.svg \)))
 
  for img in "${imgs[@]}";do
    tmp=$img
    file_name=${tmp%%.*}
    dir=${file_name%/*}
    name=${file_name##*/}
    file_tail=${tmp#*.}
    if [ "$2" == "pre" ];then
      mv "$img" "$dir"'/pre_'"$name"'.'"$file_tail"
    else
      mv "$img" "$file_name"'_suf.'"$file_tail"
    fi
  done
}

function Tojpg(){
  # 将.png\.svg图片转化为.jpg图片
  echo -e "convert png and svg to jpg\n"

 imgs=($(find "$1" -type f \( -iname \*.png -o -iname \*.svg \)))
 file_tail='jpg'

 for img in "${imgs[@]}";do
   tmp=$img
   file_name=${tmp%%.*}
   echo "$file_name"
   convert "$img" "$file_name"'.'"$file_tail" 
 done

}

function manual(){
echo "Usage:[-q|-c|-w|-r|-j]"
echo "-q [dir]                     对jpeg图片进行质量压缩"
echo "-c [dir]                     jpeg/png/svg保持高宽比压缩 "
echo "-w [dir]                     添加水印"
echo "-r [dir] [preOrsuf]          对图片名添加前缀或后缀"
echo "-j [dir]                     将目录下的png/svg图片转化为.jpg格式"
echo "-h                           帮助文档"
}



if [ "$#" -lt 1 ];then
  echo "input more information"
  exit 



else
  f=("$1")
  len=${#f}
  # 拆分命令并执行
  if [ "$len" -ge 2 ];then
    i=1
    l=1
    while [ $i -lt $len ];do
      cmd=${f:$i:$l}
      case "$cmd" in
        q) quality_reduce_jpeg "$2" ;;
        c) compress "$2" ;;
        w) water "$2" ;;
        r) rename "$2" "$3" ;;
        j) Tojpg "$2" ;;
        h) manual ;;
      esac
      i=$(($i+1))
    done
  fi
fi








  #echo -e " "$f"  :  len="$len""
  #case "$1" in

  #  -q)quality_reduce_jpeg "$2" ;;


   # -c)compress "$2" ;;

  #  -w)water "$2" ;;

  #  -r) rename "$2" "$3" ;;

  ###  -j) Tojpg "$2" ;;

 #   -h)manual ;;
#
  #  -hjh) exit ;;

 # esac









