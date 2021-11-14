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
    if [ ${count} -eq 0 ]; then
        if test -f buffer/playlist.mp4; then
            rm playlist.mp4
            mv buffer/playlist.mp4 playlist.mp4
        fi

        ./renderer.sh &
        pid=$!
        echo "renderer running"
         
        stream playlist.mp4
    else
        cp buffer/video_buffer/error.mp4 error.mp4
        stream error.mp4
    fi
    count=$(ps -A| grep ${pid} |wc -l)
done
