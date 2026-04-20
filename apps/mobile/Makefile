.PHONY: get clean build-runner watch format analyze test run build-apk build-ios build-bundle upgrade help clean-get clean-build-get

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  get              Install dependencies"
	@echo "  clean            Clean build artifacts"
	@echo "  clean-get        Clean and install dependencies"
	@echo "  clean-build-get  Clean, install dependencies, and run build-runner"
	@echo "  build-runner     Run code generation once"
	@echo "  watch            Run code generation in watch mode"
	@echo "  format           Format code"
	@echo "  analyze          Analyze code for issues"
	@echo "  test             Run tests"
	@echo "  run              Run the app"
	@echo "  build-apk        Build Android APK"
	@echo "  build-ios        Build iOS bundle"
	@echo "  build-bundle     Build Android App Bundle"
	@echo "  upgrade          Upgrade dependencies"

get:
	fvm flutter pub get

clean:
	fvm flutter clean

clean-get: clean get

clean-build-get: clean get build-runner

build-runner:
	fvm flutter pub run build_runner build --delete-conflicting-outputs

watch:
	fvm flutter pub run build_runner watch --delete-conflicting-outputs

format:
	fvm flutter format .

analyze:
	fvm flutter analyze

test:
	fvm flutter test

run:
	fvm flutter run

build-apk:
	fvm flutter build apk

build-ios:
	fvm flutter build ios

build-bundle:
	fvm flutter build appbundle

upgrade:
	fvm flutter pub upgrade
