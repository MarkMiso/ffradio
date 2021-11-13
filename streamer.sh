#!/bin/bash
stream() {
    ffmpeg -hide_banner -loglevel error -re -i ${1} -c copy -f flv rtmp://a.rtmp.youtube.com/live2/
}

if test -f buffer/playlist.mp4; then
    pid=$!
    count=0
else
    ./renderer.sh &
    pid=$!
    count=$(ps -A| grep ${pid} |wc -l)
fi

while(true); do
    if test -f buffer/playlist.mp4 && [ ${count} -eq 0 ]; then
        cp buffer/playlist.mp4 playlist.mp4
        echo "renderer running" 

        ./renderer.sh &
        pid=$!

        stream playlist.mp4
    else
        cp video/error.mp4 error.mp4
        stream error.mp4
    fi
    count=$(ps -A| grep ${pid} |wc -l)
    #echo ${count}
done


