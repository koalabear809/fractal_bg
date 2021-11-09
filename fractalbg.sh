#!/bin/bash

Help(){
  echo 'enter an argument:'
  echo '-h: display this help'
  echo '-n: get new background'
  echo '-s: save current background'
}

Get_New(){
  #clear current_bg directory
  rm /home/bryan/Documents/pics/current_bg/*

  while :
  do
    echo "querying..."
    raw_json=$(curl -s https://www.reddit.com/r/FractalPorn/rising.json)
    urls=$(echo $raw_json | jq '.data.children[].data.url')
    len=$(echo $raw_json | jq '.data.children | length')
    if (( $len > 0 )); then
      break
    fi
  done

  #random index
  index=$(($RANDOM % $len))

  random_url=$(echo $raw_json | jq -r ".data.children[$index].data.url")

  #download the file
  wget -P/home/bryan/Documents/pics/current_bg $random_url

  feh --bg-fill $(echo /home/bryan/Documents/pics/current_bg/*)
}

Save_Current(){
  echo 'saving...'
  cp /home/bryan/Documents/pics/current_bg/* /home/bryan/Documents/pics/fractals/
  echo 'saved'
}

#argument switch
while getopts ":hsn" option; do
  case $option in
    h) # display help
      Help
      exit;;
    s) # save current bg
      Save_Current
      exit;;
    n) # get new bg
      Get_New
      exit;;
  esac
done

echo 'enter an option! see help'
