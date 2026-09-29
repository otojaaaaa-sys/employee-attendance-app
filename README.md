# Employee Attendance App

A Flutter mobile app for recording employee attendance using SQLite on the device.

Features:
- Employee login and dashboard
- Multiple check-in/check-out sessions per day
- Local SQLite storage
- Attendance history and summary statistics
- Arabic RTL UI design inspired by the provided mockup

## Tech stack
- Flutter
- SQLite (sqflite)
- Provider

## Run locally

```bash
flutter pub get
flutter run
```

## App structure
- `lib/main.dart`
- `lib/app.dart`
- `lib/models/employee.dart`
- `lib/models/attendance_session.dart`
- `lib/services/database_helper.dart`
- `lib/providers/attendance_provider.dart`
- `lib/screens/login_screen.dart`
- `lib/screens/dashboard_screen.dart`
- `lib/screens/employee_detail_screen.dart`
