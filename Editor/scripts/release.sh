#!/usr/bin/env bash
#
# Builds, archives, and installs a versioned release of the Farewell to Ulster editor on an iPhone.
#
# Usage: Editor/scripts/release.sh <major.minor.patch>      e.g. Editor/scripts/release.sh 1.1.0
#        DEVICE=<udid|name> Editor/scripts/release.sh 1.1.0   to install on a different device
#
# Versioning scheme:
#   - Version (CFBundleShortVersionString) comes from the argument and is recorded as git tag editor-v<version>.
#     The "editor-" prefix keeps these tags apart from the book itself, which lives in the same repo.
#   - Build number (CFBundleVersion) is the commit count on HEAD, so it always increases on main.
#
# The archive is saved to Xcode's Archives folder, so each release (with its dSYMs) shows up
# in Window > Organizer and can be reinstalled from there if you need to roll back.

set -euo pipefail

PROJECT="Editor/FarewellToUlster/FarewellToUlster.xcodeproj"
SCHEME="FarewellToUlster"
APP_NAME="FarewellToUlster.app"
TEST_DESTINATION="platform=iOS Simulator,name=iPhone 17"
# Michael Scott's iPhone 16. Run `xcrun devicectl list devices` to find other identifiers.
DEVICE="${DEVICE:-00008140-0006681E0AD1801C}"

die() { echo "error: $*" >&2; exit 1; }
step() { echo; echo "==> $*"; }

VERSION="${1:-}"
[[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || die "usage: $0 <major.minor.patch>"
TAG="editor-v$VERSION"

cd "$(git rev-parse --show-toplevel)"

# --- Preconditions: every release must map to an exact, committed state of main.
[[ -z "$(git status --porcelain)" ]] || die "working tree has uncommitted changes"
[[ "$(git branch --show-current)" == "main" ]] || die "releases must be made from main"
if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
    die "tag $TAG already exists"
fi

# The editor commits book updates straight to origin/main, so the local branch is often behind.
git fetch -q origin main
BEHIND="$(git rev-list --count HEAD..origin/main)"
[[ "$BEHIND" -eq 0 ]] || die "main is $BEHIND commit(s) behind origin/main, run git pull first"

BUILD="$(git rev-list --count HEAD)"
ARCHIVE="$HOME/Library/Developer/Xcode/Archives/$(date +%Y-%m-%d)/$SCHEME $VERSION ($BUILD).xcarchive"
EXPORT_DIR="Editor/build/release/$VERSION"

echo "Releasing $SCHEME $VERSION (build $BUILD) from $(git rev-parse --short HEAD)"

step "Running tests"
xcodebuild test \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -destination "$TEST_DESTINATION" \
    -quiet

step "Archiving"
xcodebuild archive \
    -project "$PROJECT" \
    -scheme "$SCHEME" \
    -configuration Release \
    -destination "generic/platform=iOS" \
    -archivePath "$ARCHIVE" \
    -allowProvisioningUpdates \
    -quiet \
    MARKETING_VERSION="$VERSION" \
    CURRENT_PROJECT_VERSION="$BUILD"

step "Exporting"
rm -rf "$EXPORT_DIR"
xcodebuild -exportArchive \
    -archivePath "$ARCHIVE" \
    -exportPath "$EXPORT_DIR" \
    -exportOptionsPlist Editor/scripts/ExportOptions.plist \
    -allowProvisioningUpdates \
    -quiet

# devicectl installs an app bundle, not an .ipa, so unpack it.
IPA="$(find "$EXPORT_DIR" -maxdepth 1 -name '*.ipa' | head -n 1)"
[[ -n "$IPA" ]] || die "no .ipa found in $EXPORT_DIR"
unzip -q "$IPA" -d "$EXPORT_DIR/ipa"
APP="$EXPORT_DIR/ipa/Payload/$APP_NAME"
[[ -d "$APP" ]] || die "$APP_NAME not found in $IPA"

step "Verifying"
codesign --verify --deep --strict "$APP"
BUILT_VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$APP/Info.plist")"
BUILT_BUILD="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleVersion' "$APP/Info.plist")"
[[ "$BUILT_VERSION" == "$VERSION" && "$BUILT_BUILD" == "$BUILD" ]] \
    || die "built app reports $BUILT_VERSION ($BUILT_BUILD), expected $VERSION ($BUILD)"
echo "Signature valid, version $BUILT_VERSION ($BUILT_BUILD)"

step "Installing on $DEVICE"
# Installing over the existing app keeps its data, including unexported edits in SwiftData.
xcrun devicectl device install app --device "$DEVICE" "$APP"

step "Tagging $TAG"
git tag -a "$TAG" -m "Farewell to Ulster editor $VERSION (build $BUILD)"

echo
echo "Installed $SCHEME $VERSION ($BUILD) on $DEVICE"
echo "Archive: $ARCHIVE"
echo "Push the tag with: git push origin $TAG"
