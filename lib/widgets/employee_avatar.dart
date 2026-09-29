import 'package:flutter/material.dart';

class EmployeeAvatar extends StatelessWidget {
  final String initials;
  final int accentColorValue;
  final double radius;

  const EmployeeAvatar({
    super.key,
    required this.initials,
    required this.accentColorValue,
    this.radius = 28,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Color(accentColorValue),
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.6,
        ),
      ),
    );
  }
}
