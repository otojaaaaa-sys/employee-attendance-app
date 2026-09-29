class AttendanceSession {
  final int id;
  final int employeeId;
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final int totalMinutes;
  final String status;
  final String sessionDate;

  const AttendanceSession({
    required this.id,
    required this.employeeId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.totalMinutes,
    required this.status,
    required this.sessionDate,
  });

  factory AttendanceSession.fromMap(Map<String, dynamic> map) {
    return AttendanceSession(
      id: map['id'] as int,
      employeeId: map['employee_id'] as int,
      checkInTime: DateTime.parse(map['check_in_time'] as String),
      checkOutTime: map['check_out_time'] != null
          ? DateTime.parse(map['check_out_time'] as String)
          : null,
      totalMinutes: map['total_minutes'] as int,
      status: map['status'] as String,
      sessionDate: map['session_date'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'employee_id': employeeId,
      'check_in_time': checkInTime.toIso8601String(),
      'check_out_time': checkOutTime?.toIso8601String(),
      'total_minutes': totalMinutes,
      'status': status,
      'session_date': sessionDate,
    };
  }
}
