FLUTTER = fvm flutter

.PHONY: get clean build watch format analyze test run build-apk build-ios build-bundle upgrade help clean-get clean-build-get l10n

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  get              Install dependencies and generate localization"
	@echo "  l10n             Generate localization code"
	@echo "  clean            Clean build artifacts"
	@echo "  clean-get        Clean and install dependencies"
	@echo "  clean-build-get  Clean, install dependencies, and run build-runner"
	@echo "  build            Run code generation once"
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
	$(FLUTTER) pub get
	$(FLUTTER) gen-l10n

l10n:
	$(FLUTTER) gen-l10n

clean:
	$(FLUTTER) clean

clean-get: clean get

clean-build-get: clean get build

build:
	@echo "Building..."
	@$(FLUTTER) pub run build_runner clean
	@$(FLUTTER) pub run build_runner build --delete-conflicting-outputs --enable-experiment=dot-shorthands
	@echo "Build completed."

watch:
	$(FLUTTER) pub run build_runner watch --delete-conflicting-outputs

format:
	$(FLUTTER) format .

analyze:
	$(FLUTTER) analyze

test:
	$(FLUTTER) test

run:
	$(FLUTTER) run

build-apk:
	$(FLUTTER) build apk

build-ios:
	$(FLUTTER) build ios

build-bundle:
	$(FLUTTER) build appbundle

upgrade:
	$(FLUTTER) pub upgrade
