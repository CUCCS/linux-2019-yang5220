function quality_reduce_jpeg(){
  # 对jpeg图片进行质量压缩
echo -e "quality compress\n"
  # $1 is the directory $2 is the quality
  imgs=($(find "$1" -type f \( -iname \*.jpeg \)))
  for img in ${imgs[@]};do
    tmp=$img
    file_name=${tmp%%.*}
    tmp=$img
    file_tail=${tmp#*.}
    convert $img -quality $2 $file_name'_quality.'$file_tail 
  done

}

function compress(){
# $1 is the image directory
echo -e "compress image\n"

 imgs=($(find "$1" -type f \( -iname \*.jpeg -o -iname \*.png -o -iname \*.svg \)))
 for img in ${imgs[@]};do
   tmp=$img
   file_name=${tmp%%.*}
   file_tail=${tmp#*.}
   convert $img -resize 200x200 $file_name'_compress.'$file_tail
 done

}

function water(){
  # 添加水印
  # $1 is the image dir,$2 is the water text
  echo -e "add watermark\n"

 imgs=($(find "$1" -type f \( -iname \*.jpeg -o -iname \*.png -o -iname \*.jpg -o -iname \*.svg \)))
 num=${#imgs[@]}
 for img in ${imgs[@]};do
   tmp=$img
   file_name=${tmp%%.*}
   tmp=$img
   file_tail=${tmp#*.}

   convert $img -gravity southeast -fill black -pointsize 16 -draw "text 5,5'$2'" $file_name'_water.'$file_tail 
 done

}

function rename(){
  echo -e "add prefix or suffix\n"

# s1 is the image dir,$2 decide to add perfix or suffix 
 imgs=($(find "$1" -type f \( -iname \*.jpeg -o -iname \*.png -o -iname \*.jpg -o -iname \*.svg \)))
 
  for img in ${imgs[@]};do
    tmp=$img
    file_name=${tmp%%.*}
    dir=${file_name%/*}
    name=${file_name##*/}
    file_tail=${tmp#*.}
    if [ $2 == "pre" ];then
      mv $img $dir'/pre_'$name'.'$file_tail
    else
      mv $img $file_name'_suf.'$file_tail
    fi
  done
}

function Tojpg(){
  # 将.png\.svg图片转化为.jpg图片
  echo -e "convert png and svg to jpg\n"

 imgs=($(find "$1" -type f \( -iname \*.png -o -iname \*.svg \)))
 file_tail='jpg'

 for img in ${imgs[@]};do
   tmp=$img
   file_name=${tmp%%.*}
   convert $img $file_name'_To.'$file_tail 
 done

}

function manual(){
echo "Usage:[-q|-c|-w|-r|-j]"
echo "-q [dir] [quality-factor]    对jpeg图片进行质量压缩"
echo "-c [dir]                     jpeg/png/svg保持高宽比压缩 "
echo "-w [dir] [watermark]         添加水印"
echo "-r [dir] [preOrsuf]          对图片名添加前缀或后缀"
echo "-j [dir]                     将目录下的png/svg图片转化为.jpg格式"
echo "-h                           帮助文档"
}



if [ "$#" -lt 1 ];then
  echo "input more information"
  exit 



else
  case "$1" in

    -q)
      if [ "$#" -ne 3 ];then
        echo "the number of parameter is false"
        exit
      fi
      dir=$2
      qf=$3
      quality_reduce_jpeg $dir $qf;;


    -c)
      if [ "$#" -ne 2 ];then
        echo "the number of parameter is false"
      fi
      dir=$2
      compress $dir ;;

    -w)
      if [ "$#" -ne 3 ];then
        echo "the number of parameter is false"
      fi
      dir=$2
      watermark=$3
      water $dir $watermark ;;

    -r)
      if [ "$#" -ne 3 ];then
        echo "the number of parameter is false"
      fi
      dir=$2
      fix=$3
      rename $dir $fix ;;


    -j)
      if [ "$#" -ne 3 ];then
        echo "the number of parameter is false"
      fi
      dir=$2
      Tojpg $dir ;;

    -h)
      flag=0
      manual ;;

  esac
fi








#quality_reduce_jpeg "$1" "$2"
#water "$1" "$2"
#Tojpg "$1"
#compress "$1"
#rename "$1" "$2" 


