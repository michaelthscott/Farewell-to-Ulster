# Changelog

All notable changes to the Farewell to Ulster editor app are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

### Changed

- Renamed the `PreviewContent` folder to `Previews` and updated the Development Assets build setting to match.
- Replaced the `Previewer` helper with a `SampleData` preview modifier. The in-memory sample storage is now created once and shared across previews, which use the `.sampleData` preview trait.
- Renamed the `Model` folder to `Models`.
