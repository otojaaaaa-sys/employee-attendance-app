#!/bin/bash

# Run tests
flutter test

# Build APK
flutter build apk --release

# Build iOS
flutter build ios --release
