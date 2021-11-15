# FFradio
A simple bash script to create a 24/7 youtube radio using ffmpeg.

The scripts will automatically sync music and videos from the cloud to the running machine, this is done to make it easier to run the radio in a headless server.

# First setup
You will need to have installed:
- ffmpeg
- rclone
- bc

## rclone setup
You will need to create a rclone remote instance called playlist connected to your google drive.
```bash
# run the rclone config tool to create the remote instance
$ rclone config
```

You will also need a folder *in you google drive* called ffradio, inside that folder you will have to create 2 other folders:
- music:
    - this folder will contain all mp3 files
    - the name of the files is used to generate subtitles to show the name of the song and artist on the video, it's important that the name of the music files follows this formatting `song_name-song_artist.mp3`
    - all underscore `_` characters will be rendered on the video as space ` ` characters
    - all dash `-` characters will be rendered on the video ad endline `\n` characters
    - any other character excluding alphanumeric and the comma `,` will probalbly cause issues.
- video
    - this folder will contain 2 mp4 files
    - `loop.mp4` will be the main video loop to display
    - `error.mp4` will be a secondary video loop to dispaly when something goes wrong

## ffradio setup
After having correctly setup rclone you can run the setup script and the render script.
```bash
# cd in the ffradio folder and run the setup script to generate all needed folders and render a first palylist
$ cd ffradio
$ ./setup.sh
```

# Running the scripts
Before running any of the scripts make sure you have compleated the first setup

## in a terminal

```bash
# cd in the ffradio folder and start the streamer script
$ cd ffradio/
$ ./streamer.sh
```

> Note that once you close the terminal the stream will stop

## as a background process
```bash
$ cd ffradio/
$ ./streamer.sh >dev/null 2>&1 &
```

## in a headless server as a background process using ssh
```bash
# start the streamer script as a background process in your server
$ ssh user@server "cd /home/user/ffradio/; ./streamer.sh >/dev/null 2>&1 &"
```
