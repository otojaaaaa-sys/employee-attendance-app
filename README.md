# Employee Attendance App

## 📱 تطبيق تسجيل حضور الموظفين

تطبيق Flutter لتسجيل حضور الموظفين دخول وخروج عدة مرات في اليوم مع قاعدة بيانات محلية SQLite على الجهاز.

### الميزات ✨

- ✅ تسجيل دخول الموظفين
- ✅ تسجيل دخول وخروج متعدد في اليوم
- ✅ قاعدة بيانات محلية SQLite
- ✅ إحصائيات الحضور والغياب والتأخر
- ✅ سجل حضور لكل موظف
- ✅ واجهة عربية RTL
- ✅ تصميم حديث وسهل الاستخدام

### البدء السريع 🚀

#### المتطلبات
- Flutter SDK 3.0.0 أو أحدث
- Android Studio أو VS Code
- أجهزة اختبار أو محاكي Android

#### التثبيت والتشغيل

1. **استنساخ المستودع**
   ```bash
   git clone https://github.com/otojaaaaa-sys/employee-attendance-app.git
   cd employee-attendance-app
   ```

2. **تحديث Flutter**
   ```bash
   flutter upgrade
   flutter pub get
   ```

3. **تشغيل التطبيق**
   ```bash
   flutter run
   ```

### فتح في Android Studio 📂

1. افتح Android Studio
2. اختر `Open an Existing Project`
3. اختر مجلد `employee-attendance-app`
4. اتبع التعليمات لتثبيت Flutter و Dart
5. اضغط `Run` أو استخدم `Shift + F10`

### بناء APK 📦

```bash
flutter build apk --release
```

سيتم إنشاء الملف في:
```
build/app/outputs/flutter-apk/app-release.apk
```

### هيكل المشروع 📁

```
employee-attendance-app/
├── android/              # ملفات Android
├── lib/
│   ├── main.dart
│   ├── app.dart
│   ├── models/
│   │   ├── employee.dart
│   │   └── attendance_session.dart
│   ├── services/
│   │   └── database_helper.dart
│   ├── providers/
│   │   └── attendance_provider.dart
│   ├── screens/
│   │   ├── login_screen.dart
│   │   ├── dashboard_screen.dart
│   │   └── employee_detail_screen.dart
│   ├── widgets/
│   │   ├── employee_avatar.dart
│   │   ├── status_badge.dart
│   │   └── stat_card.dart
│   └── utils/
│       ├── app_theme.dart
│       └── date_utils.dart
├── pubspec.yaml
└── README.md
```

### قاعدة البيانات 🗄️

#### جدول الموظفين (employees)
```sql
CREATE TABLE employees (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  role TEXT NOT NULL,
  initials TEXT NOT NULL,
  accent_color INTEGER NOT NULL
)
```

#### جدول جلسات الحضور (attendance_sessions)
```sql
CREATE TABLE attendance_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  employee_id INTEGER NOT NULL,
  check_in_time TEXT NOT NULL,
  check_out_time TEXT,
  total_minutes INTEGER NOT NULL DEFAULT 0,
  status TEXT NOT NULL,
  session_date TEXT NOT NULL,
  FOREIGN KEY (employee_id) REFERENCES employees(id)
)
```

### الموظفون الافتراضيون 👥

1. أحمد علي - مبرمج
2. سارة محمد - مديرة مشاريع
3. ياسر نبيل - محاسب
4. ليلى أحمد - مصممة
5. محمود سالم - مبيعات

### التطوير 💻

#### تشغيل الاختبارات
```bash
flutter test
```

#### تنسيق الكود
```bash
flutter format lib/
```

#### تحليل الكود
```bash
flutter analyze
```

### المتطلبات والمكتبات 📚

- **Flutter**: إطار العمل الأساسي
- **sqflite**: قاعدة بيانات SQLite
- **Provider**: إدارة الحالة
- **intl**: دعم اللغات والتاريخ
- **path_provider**: الوصول لمسارات الملفات
- **shared_preferences**: تخزين البيانات المحلية

### المساهمة 🤝

1. Fork المستودع
2. أنشئ فرع جديد (`git checkout -b feature/AmazingFeature`)
3. Commit التغييرات (`git commit -m 'Add some AmazingFeature'`)
4. Push للفرع (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### الترخيص 📄

هذا المشروع مرخص تحت MIT License - انظر ملف [LICENSE](LICENSE) للتفاصيل.

### الدعم 📧

إذا واجهت مشاكل أو لديك أسئلة، يرجى فتح issue في المستودع.

---

**تم إنشاؤه بـ ❤️ بواسطة Copilot**
