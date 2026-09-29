import 'package:flutter/material.dart';

import '../models/attendance_session.dart';
import '../models/employee.dart';
import '../services/database_helper.dart';

class AttendanceProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<Employee> employees = [];
  List<AttendanceSession> sessions = [];
  bool isLoading = true;
  Map<String, int> summary = {
    'inside': 0,
    'completed': 0,
    'late': 0,
    'absent': 0,
  };

  Future<void> initialize() async {
    await loadEmployees();
    await refreshSummary();
    isLoading = false;
    notifyListeners();
  }

  Future<void> loadEmployees() async {
    employees = await _db.fetchEmployees();
    notifyListeners();
  }

  Future<void> refreshSummary() async {
    summary = await _db.fetchSummary();
    notifyListeners();
  }

  Future<void> toggleAttendance(Employee employee) async {
    final active = await _db.getActiveSessionForEmployee(employee.id);

    if (active == null) {
      await _db.startAttendance(employee.id);
    } else {
      await _db.endAttendance(employee.id);
    }

    await loadEmployees();
    await refreshSummary();
  }

  Future<List<AttendanceSession>> getEmployeeSessions(int employeeId) async {
    final items = await _db.fetchSessionsForEmployee(employeeId);
    sessions = items;
    notifyListeners();
    return items;
  }

  Future<bool> isCheckedIn(Employee employee) async {
    final active = await _db.getActiveSessionForEmployee(employee.id);
    return active != null;
  }
}
