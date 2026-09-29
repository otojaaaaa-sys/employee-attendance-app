class Employee {
  final int id;
  final String fullName;
  final String role;
  final String initials;
  final int accentColorValue;

  const Employee({
    required this.id,
    required this.fullName,
    required this.role,
    required this.initials,
    required this.accentColorValue,
  });

  factory Employee.fromMap(Map<String, dynamic> map) {
    return Employee(
      id: map['id'] as int,
      fullName: map['full_name'] as String,
      role: map['role'] as String,
      initials: map['initials'] as String,
      accentColorValue: map['accent_color'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'role': role,
      'initials': initials,
      'accent_color': accentColorValue,
    };
  }
}
