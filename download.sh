#!/usr/bin/env sh

BASE_URL='https://recording.tk.informatik.tu-darmstadt.de'
COURSES_URL="$BASE_URL/assets/courses.json"

DEBUG=0

# get all courses
# curl -o courses.json "$COURSES_URL"

# download all lecture information for a course
# curl -o lectures.json "$BASE_URL/videos/TK1/WS2021/assets/lecture.json"

download_courses() {
  	curl "$COURSES_URL" \
      | jq '[.[] | .folder | capture("^(.*)/(?<course>.*)/(?<term>.*)$") | {course: .course, term: .term}]'\
      > courses.json
}

fetch_all_lectures() {
  courses=$(cat courses.json)
  for row in $(echo "$courses" | jq -c '.[]'); do
      _jq() {
        echo ${row} | jq -r ${1}
      }

    lecture_url $(_jq '.course') $(_jq '.term')
  done
}

# unused
lecture_url_video() {
  local name="$1"
  if [ -z "$name" ]; then
    echo "Please provide a lecture name."
    return
  fi
  echo "$BASE_URL/$name/assets/lecture.json"
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
  return 0
}

download_lecture_json() {
  curl "$1" \
    | jq '.recordings[] | {file: .fileName, slides: [.slides[] | {startPosition: .startPosition}], duration: .duration}'\
    > lectures.json
}

main() {
  # download_courses
  # fetch_all_lectures
  download_lecture_json "https://recording.tk.informatik.tu-darmstadt.de/videos/CNuvS/SoSe20/assets/lecture.json"
  return 0

  video="$1"
  if [ ! -z "$video" ]; then
    lecture_url "$video"
  else
    lecture_url "TK1" "WS2021"
  fi
}

main
