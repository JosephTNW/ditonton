#!/bin/bash
# Script to run tests and collect coverage for all modules
# This will merge coverage from core, movies, tv, and main app
# Uses test_cov_console for generating coverage reports

echo "======================================"
echo "Running Tests for All Modules"
echo "======================================"

# Test Core Module
echo -e "\n[1/4] Testing Core Module..."
cd core
flutter test 
if [ $? -ne 0 ]; then
    echo "Core tests failed!"
    cd ..
    exit 1
fi
cd ..

# Test Movies Module
echo -e "\n[2/4] Testing Movies Module..."
cd movies
flutter test 
if [ $? -ne 0 ]; then
    echo "Movies tests failed!"
    cd ..
    exit 1
fi
cd ..

# Test TV Module
echo -e "\n[3/4] Testing TV Module..."
cd tv
flutter test 
if [ $? -ne 0 ]; then
    echo "TV tests failed!"
    cd ..
    exit 1
fi
cd ..

# Test Main App
echo -e "\n[4/4] Testing Main App..."
flutter test 
if [ $? -ne 0 ]; then
    echo "Main app tests failed!"
    exit 1
fi
echo "All tests passed!"