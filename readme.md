# TCL Lecture downloader

Download all video files (720p) and slides information from
https://recording.tk.informatik.tu-darmstadt.de/ for research purposes.

## Requirements 

* Unix Shell
* curl (`curl --version`)
* jq (`jq --version`)
* a working Internet connection (`ping -c 5 betterworld.mit.edu`)

## Installation

```sh
git clone https://github.com/weiland/tcl-lecture-downloader.git

cd tcl-lecture-downloader
```

## Run

```sh
# download all json files and lecture videos
make

# clean up
make clean
```

* The videos are located in the newly created `videos/` directory being named `video_TERM_COURSE.mp4`.
* The most important meta information is located in `lectures_TERM_COURSE.json`
* The `courses.json` contains all courses available.

Now you could pipe a video using *mkv*, *VLC*, *OBS*, *ffmpeg* or perhaps *imagick*
into the Detector.

All video slides can be found in the corresponding json file.
