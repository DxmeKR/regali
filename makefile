# FIREBASE FUNCTIONS
deploy-functions-dev:
	firebase deploy --only functions --project regali-dxme

# WEB
web-dev:
	flutter build web -t lib/main.dart --dart-define=ENV=dev --release --no-tree-shake-icons

deploy-web-dev: web-dev
	firebase deploy --only hosting:regali-dxme --project regali-dxme

web-prod:
	flutter build web -t lib/main.dart --dart-define=ENV=prod --release --no-tree-shake-icons

run-prod:
	flutter run -t lib/main.dart --dart-define=ENV=prod

# UPDATE LAUNCHER ICONS
update-icons:
	dart run flutter_launcher_icons