.PHONY: download clean_courses clean_lectures clean

download: download.sh videos
	sh download.sh

videos:
	mkdir videos

clean_videos:
	rm -r videos

clean_courses: courses.json
	rm courses.json

clean_lectures:
	$(shell rm lectures_*.json)

clean: clean_lectures clean_courses clean_videos

