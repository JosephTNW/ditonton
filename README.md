# Ditonton

A Flutter movie and TV series application with modular architecture.

## Project Structure

This project is organized into multiple modules:

- **core** - Shared utilities, constants, and common functionality
- **movies** - Movie-related features and functionality
- **tv** - TV series-related features and functionality
- **main app** - Application entry point and integration

## Getting Started

### Prerequisites

- Flutter SDK ^3.7.2
- Dart SDK ^3.7.2

### Installation

1. Clone the repository
2. Install dependencies for all modules:

```bash
flutter pub get
cd core && flutter pub get && cd ..
cd movies && flutter pub get && cd ..
cd tv && flutter pub get && cd ..
```

3. Run build_runner (if needed):

```bash
cd movies && flutter pub run build_runner build --delete-conflicting-outputs && cd ..
```

### Running the App

```bash
flutter run
```

## Testing & Coverage

This project maintains a **95% test coverage** requirement across all modules.

To run testing on all modules do:

```bash
flutter test test/ core/test/ movies/test/ tv/test/
```

### Build Badge:
[![Codemagic build status](https://api.codemagic.io/apps/691b4ea897a38412fd632840/691b4ea897a38412fd63283f/status_badge.svg)](https://codemagic.io/app/691b4ea897a38412fd632840/691b4ea897a38412fd63283f/latest_build)
