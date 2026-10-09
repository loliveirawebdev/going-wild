IOS_SIMULATOR ?= $(shell xcrun simctl list devices booted | grep -m1 iPhone | grep -oE '[0-9A-F-]{36}' || xcrun simctl list devices available | grep -m1 iPhone | grep -oE '[0-9A-F-]{36}')
ANDROID_EMULATOR ?= $(shell flutter emulators 2>/dev/null | grep '• android' | head -1 | awk '{print $$1}')

.PHONY: ios android design-system-catalog sync-slang pack-unit-atlases

ios: sync-slang
	@test -n "$(IOS_SIMULATOR)" || (echo "No iPhone simulator found. Install one in Xcode > Settings > Components." && exit 1)
	xcrun simctl bootstatus "$(IOS_SIMULATOR)" -b
	open -a Simulator
	flutter run -d "$(IOS_SIMULATOR)"

android: sync-slang
	@adb devices | grep -q "^emulator-" || test -n "$(ANDROID_EMULATOR)" || (echo "No Android emulator found. Create one in Android Studio > Device Manager." && exit 1)
	adb devices | grep -q "^emulator-" || flutter emulators --launch "$(ANDROID_EMULATOR)"
	adb wait-for-device
	until [ "$$(adb shell getprop sys.boot_completed | tr -d '\r')" = "1" ]; do sleep 1; done
	flutter run -d emulator

design-system-catalog:
	@test -n "$(IOS_SIMULATOR)" || (echo "No iPhone simulator found. Install one in Xcode > Settings > Components." && exit 1)
	xcrun simctl bootstatus "$(IOS_SIMULATOR)" -b
	open -a Simulator
	flutter run -d "$(IOS_SIMULATOR)" -t lib/main_design_system_catalog.dart

sync-slang:
	dart run slang

pack-unit-atlases:
	@test -n "$(ATLASES)" || (echo "Usage: make pack-unit-atlases ATLASES=<folder with the delivered <name>.png atlases>" && exit 1)
	dart run tool/pack_unit_atlases.dart "$(ATLASES)"
