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

The coverage scripts use `test_cov_console` to generate formatted coverage reports in the terminal.

### Quick Start - Run All Tests with Coverage

**Windows (PowerShell):**

```powershell
.\test_all_coverage.ps1
```

**Linux/macOS (Bash):**

```bash
chmod +x test_all_coverage.sh
./test_all_coverage.sh
```

The script will:

- Automatically install `test_cov_console` if needed
- Run tests for all modules (core, movies, tv, main)
- Merge coverage data
- Display a formatted coverage report in your terminal

### Check Current Coverage

```powershell
.\check_coverage.ps1
```

### View Coverage Report

The `test_cov_console` tool displays coverage directly in the terminal. For HTML reports, optionally install lcov:

```powershell
choco install lcov
genhtml coverage/lcov.info -o coverage/html
```

### VS Code Integration

Use VS Code tasks (Ctrl+Shift+P → "Tasks: Run Task"):

- **Test All Modules with Coverage** - Run all tests and generate coverage
- **Check Coverage Summary** - Quick coverage percentage check
- **Open Coverage Report** - Open HTML report in browser (if generated)

**Recommended Extension:** Install "Coverage Gutters" to see coverage inline in your code.

For detailed coverage documentation, see [COVERAGE.md](COVERAGE.md).

For available commands, see [COMMANDS.md](COMMANDS.md).

## Resources

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)
