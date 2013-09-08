default:
	# Set default make action here
	# xcodebuild -target Tests -configuration MyMainTarget -sdk iphonesimulator build	

clean:
	-rm -rf build/*

test:
	GHUNIT_CLI=1 xcodebuild ONLY_ACTIVE_ARCH=NO -workspace rensou.xcworkspace -scheme GHUnit -configuration Debug -sdk iphonesimulator build

