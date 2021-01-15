#!/usr/bin/env sh

BASE_URL='https://recording.tk.informatik.tu-darmstadt.de'
VIDEOS_URL="$BASE_URL/videos"
COURSES_URL="$BASE_URL/assets/courses.json"

DEBUG=0

download_courses() {
  	curl --silent --fail "$COURSES_URL" \
      | jq '[.[] | .folder | capture("^(.*)/(?<course>.*)/(?<term>.*)$") | {course: .course, term: .term}]'\
      > courses.json
}

fetch_all_lectures() {
  local courses=$(cat courses.json)
  for row in $(echo "$courses" | jq -c '.[]'); do
      _jq() {
        echo ${row} | jq -r ${1}
      }

    download_lecture_json $(_jq '.course') $(_jq '.term')
    download_videos $(_jq '.course') $(_jq '.term')
  done
}

lecture_url() {
  local course="$1"
  local term="$2"
  if [ -z "$course" ]; then
    echo "Please provide a course name (first argument)."
    return
  fi
  if [ -z "$term" ]; then
    echo "Please provide a term name (second argument)."
    return
  fi
  echo "$BASE_URL/videos/$course/$term/assets/lecture.json"
}

download_lecture_json() {
  local course="$1"
  local term="$2"
  local url=$(lecture_url "$course" "$term")
  local target=lectures_"$term"_"$course".json
  local tmp=tmp_"$term"_"$course".json
  if [ -f "$target" ]; then
    echo "'$target' did already exists. (Run 'make clean' to delete all files)"
    return
  fi
  curl --fail --silent -o "$tmp" "$url"
  if [ ! -f "$tmp" ]; then
    echo "'$url' returned 404"
    return
  fi
  cat "$tmp" | jq '.recordings[] | {file: .fileName, slides: [.slides[] | {startPosition: .startPosition}], duration: .duration}'\
    > "$target"
  echo "$target"
  rm "$tmp"
}

download_videos() {
  local course="$1"
  local term="$2"
  local target=lectures_"$term"_"$course".json
  local videos=$(cat "$target")
  for video in $(echo "$videos" | jq -c '.file'); do
    _jq() {
      echo ${video} | jq -r 'capture("^video/(?<id>.*)/output(.*)$") | .id'
    }
    # echo $(_jq 'capture("^video/(?<id>.*)/output(.*)$") | .id')
    target="videos/video_$term"_"$course"$(_jq).mp4
    url="$VIDEOS_URL/$course/$term/$(echo "$video" | jq -r)"
    curl --fail -o "$target" "$url"
  done
}

main() {
  download_courses
  fetch_all_lectures
}

main
