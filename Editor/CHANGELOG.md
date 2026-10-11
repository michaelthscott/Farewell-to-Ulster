# Changelog

All notable changes to the Farewell to Ulster editor app are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Versions follow [Semantic Versioning](https://semver.org): MAJOR.MINOR.PATCH. Each release is tagged `editor-vMAJOR.MINOR.PATCH`.

## [1.0.0]

### Added

- Versioned release pipeline: `Editor/scripts/release.sh` tests, archives, and installs a release on the iPhone, and tags it.
- The Book tab menu shows the app version and build number.

### Fixed

- Release builds failed to compile because previews referenced `SampleData`, which is a development asset left out of archives. Previews that use it are now wrapped in `#if DEBUG`.

### Changed

- Renamed the `PreviewContent` folder to `Previews` and updated the Development Assets build setting to match.
- Replaced the `Previewer` helper with a `SampleData` preview modifier. The in-memory sample storage is now created once and shared across previews, which use the `.sampleData` preview trait.
- Renamed the `Model` folder to `Models`.
- Replaced the `AppIcon` asset catalog icon set with an Icon Composer `AppIcon.icon` file. The map image now has a transparent background in place of solid white.
