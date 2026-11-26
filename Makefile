APP := build/Build/Products/Release/TwoMonthCalendar.app

.PHONY: project build install clean

project:
	xcodegen generate

build: project
	xcodebuild -project TwoMonthCalendar.xcodeproj -scheme TwoMonthCalendar \
		-configuration Release -derivedDataPath build build

install: build
	rm -rf /Applications/TwoMonthCalendar.app
	cp -R $(APP) /Applications/
	open /Applications/TwoMonthCalendar.app

clean:
	rm -rf build TwoMonthCalendar.xcodeproj
