#!/usr/bin/env bash
#
# Refreshes the editor's bundled seed data from the canonical copy in the site repo.
#
# Usage: Editor/scripts/refresh-seed.sh
#
# The editor commits the book to _data/Farewell-to-Ulster.json in michaelthscott/Farewell-to-Ulster.
# The copy in the asset catalog is only used to seed SwiftData on first launch (see Storage.loadData),
# so it just needs to be current when a release is built. release.sh runs this script.
#
# The file is fetched through the GitHub API rather than raw.githubusercontent.com, whose CDN can
# serve a stale copy for several minutes after a Commit update.

set -euo pipefail

SOURCE="https://api.github.com/repos/michaelthscott/Farewell-to-Ulster/contents/_data/Farewell-to-Ulster.json?ref=main"
# Relative to this script, so it works wherever the editor's repo is checked out.
DEST="$(cd "$(dirname "$0")/.." && pwd)/FarewellToUlster/FarewellToUlster/Assets.xcassets/Farewell-to-Ulster.dataset/Farewell-to-Ulster.json"

die() { echo "error: $*" >&2; exit 1; }

[[ -f "$DEST" ]] || die "seed file not found at $DEST"

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT

curl -fsSL -H "Accept: application/vnd.github.raw" -o "$TMP" "$SOURCE" \
    || die "could not download $SOURCE"

# Refuse to replace the seed with something that isn't JSON, e.g. an error page.
python3 -m json.tool "$TMP" >/dev/null || die "downloaded file is not valid JSON"

if cmp -s "$TMP" "$DEST"; then
    echo "Seed data is already current"
else
    cp "$TMP" "$DEST"
    echo "Seed data refreshed from $SOURCE"
fi
