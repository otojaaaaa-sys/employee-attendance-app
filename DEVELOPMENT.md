# Getting Started with Flutter

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio or Xcode (for mobile development)

## Installation

1. Clone the repository
```bash
git clone https://github.com/otojaaaaa-sys/employee-attendance-app.git
cd employee-attendance-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # Entry point
├── app.dart                  # App configuration
├── models/
│   ├── employee.dart
│   └── attendance_session.dart
├── services/
│   └── database_helper.dart
├── providers/
│   └── attendance_provider.dart
├── screens/
│   ├── login_screen.dart
│   ├── dashboard_screen.dart
│   └── employee_detail_screen.dart
├── widgets/
│   ├── employee_avatar.dart
│   ├── status_badge.dart
│   └── stat_card.dart
└── utils/
    ├── app_theme.dart
    └── date_utils.dart
```

## Features

- ✅ Employee login
- ✅ Check-in/Check-out tracking
- ✅ Multiple sessions per day
- ✅ Local SQLite database
- ✅ Attendance statistics
- ✅ Employee detail view
- ✅ Arabic RTL UI

## Development

### Creating a new screen

```dart
import 'package:flutter/material.dart';

class NewScreen extends StatefulWidget {
  const NewScreen({super.key});

  @override
  State<NewScreen> createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Title')),
      body: const Center(child: Text('Content')),
    );
  }
}
```

### Database schema

**employees table:**
- id (INTEGER PRIMARY KEY)
- full_name (TEXT)
- role (TEXT)
- initials (TEXT)
- accent_color (INTEGER)

**attendance_sessions table:**
- id (INTEGER PRIMARY KEY)
- employee_id (INTEGER FOREIGN KEY)
- check_in_time (TEXT)
- check_out_time (TEXT)
- total_minutes (INTEGER)
- status (TEXT)
- session_date (TEXT)

## Contributing

Fork the repository and submit a pull request with your improvements.

## License

MIT License
