.PHONY: download clean_courses clean_lectures clean check

JQ := $(shell command -v jq 2> /dev/null)
CURL := $(shell command -v curl 2> /dev/null)

download: download.sh videos check
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

check:
    ifndef JQ
	$(error "jq is not available please install jq")
    endif
    ifndef CURL
	$(error "curl is not available please install curl")
    else
	@echo "All good"
    endif

