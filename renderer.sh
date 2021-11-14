#!/bin/bash

### PLAYLIST CREATION ###
cd buffer/
rm song_buffer.txt
printf "ffconcat version 1.0\n" > song_buffer.txt
rm song_buffer.srt
touch song_buffer.srt

cd song_buffer/
counter=1
duration=0.0
for f in $(ls *.mp3 | shuf); do
    echo "file 'song_buffer/${f}'" >> ../song_buffer.txt
    echo "${counter}" >> ../song_buffer.srt

    h="$(echo "scale=0; (${duration} / 3600) / 1" | bc)"
    m="$(echo "scale=0; ((${duration} / 60 ) % 60) / 1" | bc)"
    s="$(echo "scale=0; (${duration} % 60) / 1" | bc)"
    d="$(echo "scale=0; ((${duration} % 1 ) * 1000) / 1" | bc)"
    printf "%02d:%02d:%02d,%03d --> " ${h} ${m} ${s} ${d} >> ../song_buffer.srt

    duration="$(echo "${duration} + $(ffprobe -i ${f} -show_entries format=duration -v quiet -of csv="p=0")" | bc)"

    h="$(echo "scale=0; (${duration} / 3600) / 1" | bc)"
    m="$(echo "scale=0; ((${duration} / 60 ) % 60) / 1" | bc)"
    s="$(echo "scale=0; (${duration} % 60) / 1" | bc)"
    d="$(echo "scale=0; ((${duration} % 1 ) * 1000) / 1" | bc)"
    printf "%02d:%02d:%02d,%03d\n" ${h} ${m} ${s} ${d} >> ../song_buffer.srt

    string=${f::-4}
    artist_song=$(echo ${string} | tr '-' '\n')
    for s in ${artist_song}; do
        echo "${s//_/ }" >> ../song_buffer.srt
    done
    echo "" >> ../song_buffer.srt

    let counter++
done
cd ..

### PLAYLIST RENDERING ###
fadestart="$(echo "${duration} - 3" | bc)"
ffmpeg -hide_banner -loglevel error -stream_loop -1 -i video_buffer/loop.mp4 -f concat -i song_buffer.txt -vf \
    "subtitles=song_buffer.srt:force_style='Fontsize=14,PrimaryColour=&Hffffff&,BorderStyle=1',\
    fade=t=in:st=0:d=3,\
    fade=t=out:st=${fadestart}:d=3" \
    -shortest -map 0:v:0 -map 1:a:0 \
    -c:v libx264 -preset veryfast -crf 20 \
    -c:a copy playlist.mp4

### BUFFER UPDATE ###
rclone sync playlist:ffradio/music/ ./song_buffer/
rclone sync playlist:ffradio/video/ ./video_buffer/
