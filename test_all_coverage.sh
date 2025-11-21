#!/bin/bash
# Script to run tests and collect coverage for all modules
# This will merge coverage from core, movies, tv, and main app
# Uses test_cov_console for generating coverage reports

echo "======================================"
echo "Running Tests with Coverage for All Modules"
echo "======================================"

# Check if test_cov_console is installed
echo -e "\nChecking for test_cov_console..."
if ! flutter pub global list | grep -q "test_cov_console"; then
    echo "test_cov_console not found. Installing..."
    flutter pub global activate test_cov_console
    if [ $? -ne 0 ]; then
        echo "Failed to install test_cov_console!"
        exit 1
    fi
    echo "test_cov_console installed successfully!"
else
    echo "test_cov_console is already installed"
fi

# Clean up old coverage data
echo -e "\nCleaning up old coverage data..."
rm -rf coverage core/coverage movies/coverage tv/coverage

# Create coverage directory
mkdir -p coverage

# Test Core Module
echo -e "\n[1/4] Testing Core Module..."
cd core
flutter test --coverage
if [ $? -ne 0 ]; then
    echo "Core tests failed!"
    cd ..
    exit 1
fi
cp coverage/lcov.info ../coverage/lcov.core.info
cd ..

# Test Movies Module
echo -e "\n[2/4] Testing Movies Module..."
cd movies
flutter test --coverage
if [ $? -ne 0 ]; then
    echo "Movies tests failed!"
    cd ..
    exit 1
fi
cp coverage/lcov.info ../coverage/lcov.movies.info
cd ..

# Test TV Module
echo -e "\n[3/4] Testing TV Module..."
cd tv
flutter test --coverage
if [ $? -ne 0 ]; then
    echo "TV tests failed!"
    cd ..
    exit 1
fi
cp coverage/lcov.info ../coverage/lcov.tv.info
cd ..

# Test Main App
echo -e "\n[4/4] Testing Main App..."
flutter test --coverage
if [ $? -ne 0 ]; then
    echo "Main app tests failed!"
    exit 1
fi
cp coverage/lcov.info coverage/lcov.main.info

# Merge all coverage files
echo -e "\nMerging coverage files..."
cat coverage/lcov.core.info coverage/lcov.movies.info coverage/lcov.tv.info coverage/lcov.main.info > coverage/lcov.info
echo "Coverage files merged successfully!"

# Generate coverage report using test_cov_console
echo -e "\nGenerating coverage report..."
flutter pub global run test_cov_console

if [ $? -eq 0 ]; then
    echo -e "\n✓ Coverage report generated successfully!"
else
    echo -e "\nNote: test_cov_console completed with warnings"
fi

echo -e "\n======================================"
echo "Coverage report saved to: coverage/lcov.info"
echo "======================================"
