import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/attendance_session.dart';
import '../models/employee.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'employee_attendance.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE employees (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        role TEXT NOT NULL,
        initials TEXT NOT NULL,
        accent_color INTEGER NOT NULL
      )
    ''');

    await db.execute('''
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
    ''');

    await _seedDefaultEmployees(db);
  }

  Future<void> _seedDefaultEmployees(Database db) async {
    final defaultEmployees = [
      Employee(
        id: 1,
        fullName: 'أحمد علي',
        role: 'مبرمج',
        initials: 'أح',
        accentColorValue: 0xFFB71C1C,
      ),
      Employee(
        id: 2,
        fullName: 'سارة محمد',
        role: 'مديرة مشاريع',
        initials: 'س',
        accentColorValue: 0xFF1E88E5,
      ),
      Employee(
        id: 3,
        fullName: 'ياسر نبيل',
        role: 'محاسب',
        initials: 'ي',
        accentColorValue: 0xFF43A047,
      ),
      Employee(
        id: 4,
        fullName: 'ليلى أحمد',
        role: 'مصممة',
        initials: 'ل',
        accentColorValue: 0xFFFFA000,
      ),
      Employee(
        id: 5,
        fullName: 'محمود سالم',
        role: 'مبيعات',
        initials: 'م',
        accentColorValue: 0xFF6D4C41,
      ),
    ];

    for (final employee in defaultEmployees) {
      await db.insert('employees', employee.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Employee>> fetchEmployees() async {
    final db = await database;
    final maps = await db.query('employees', orderBy: 'id ASC');
    return maps.map((m) => Employee.fromMap(m)).toList();
  }

  Future<Employee?> fetchEmployeeById(int id) async {
    final db = await database;
    final maps = await db.query(
      'employees',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) return null;
    return Employee.fromMap(maps.first);
  }

  Future<List<AttendanceSession>> fetchSessionsForEmployee(int employeeId) async {
    final db = await database;
    final maps = await db.query(
      'attendance_sessions',
      where: 'employee_id = ?',
      whereArgs: [employeeId],
      orderBy: 'check_in_time DESC',
    );

    return maps.map((m) => AttendanceSession.fromMap(m)).toList();
  }

  Future<AttendanceSession?> getActiveSessionForEmployee(int employeeId) async {
    final db = await database;
    final maps = await db.query(
      'attendance_sessions',
      where: 'employee_id = ? AND status = ?',
      whereArgs: [employeeId, 'inside'],
      orderBy: 'check_in_time DESC',
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return AttendanceSession.fromMap(maps.first);
  }

  Future<void> startAttendance(int employeeId, {DateTime? at}) async {
    final db = await database;
    final now = at ?? DateTime.now();
    final sessionDate = now.toIso8601String().split('T').first;

    await db.insert('attendance_sessions', {
      'employee_id': employeeId,
      'check_in_time': now.toIso8601String(),
      'check_out_time': null,
      'total_minutes': 0,
      'status': 'inside',
      'session_date': sessionDate,
    });
  }

  Future<void> endAttendance(int employeeId, {DateTime? at}) async {
    final db = await database;
    final active = await getActiveSessionForEmployee(employeeId);
    if (active == null) return;

    final now = at ?? DateTime.now();
    final diff = now.difference(active.checkInTime).inMinutes;

    await db.update(
      'attendance_sessions',
      {
        'check_out_time': now.toIso8601String(),
        'total_minutes': diff < 0 ? 0 : diff,
        'status': 'completed',
      },
      where: 'id = ?',
      whereArgs: [active.id],
    );
  }

  Future<Map<String, int>> fetchSummary() async {
    final db = await database;
    final rows = await db.query('attendance_sessions');

    int active = 0;
    int completed = 0;
    int late = 0;

    for (final row in rows) {
      final status = row['status'] as String;
      if (status == 'inside') {
        active++;
      } else {
        completed++;
      }

      final checkIn = DateTime.parse(row['check_in_time'] as String);
      final hour = checkIn.hour;
      if (hour > 9 || (hour == 9 && checkIn.minute > 0)) {
        late++;
      }
    }

    return {
      'inside': active,
      'completed': completed,
      'late': late,
      'absent': 0,
    };
  }
}
