#!/bin/bash
stream() {
    echo "streaming ${1}"
    ffmpeg -hide_banner -loglevel error -re -i ${1} -c copy -f flv rtmp://a.rtmp.youtube.com/live2/
    echo "stream ended"
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
        mv buffer/playlist.mp4 playlist.mp4

        ./renderer.sh &
        pid=$!
         
        stream playlist.mp4
    else
        if [ ${count} -eq 0 ]; then
            ./renderer.sh &
            pid=$!
        fi

        cp buffer/video_buffer/error.mp4 error.mp4
        stream error.mp4
    fi
    count=$(ps -A| grep ${pid} |wc -l)
done
