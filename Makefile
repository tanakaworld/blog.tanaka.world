# Dependencies
# - brew install hugo
# - brew install gnu-sed

new:
	$(eval today := $(shell date +"%Y-%m-%d"))
	$(eval file_path := "posts/$(today)-$(slug).md")

	hugo new $(file_path)
	gsed -i "3islug: $(slug)" "content/${file_path}"
	mkdir static/images/$(today)-$(slug)

run:
	hugo -D server

deploy:
	./publish_to_ghpages.sh
