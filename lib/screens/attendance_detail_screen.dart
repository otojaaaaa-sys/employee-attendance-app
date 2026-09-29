import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/attendance_session.dart';
import '../models/employee.dart';
import '../providers/attendance_provider.dart';
import '../widgets/employee_avatar.dart';
import '../widgets/status_badge.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final Employee employee;

  const AttendanceDetailScreen({super.key, required this.employee});

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee.fullName),
        elevation: 0,
      ),
      body: FutureBuilder<List<AttendanceSession>>(
        future: provider.getEmployeeSessions(widget.employee.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final sessions = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(widget.employee.accentColorValue),
                        Color(widget.employee.accentColorValue).withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          EmployeeAvatar(
                            initials: widget.employee.initials,
                            accentColorValue: widget.employee.accentColorValue,
                            radius: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.employee.fullName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.employee.role,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatItem(
                            label: 'إجمالي الجلسات',
                            value: sessions.length.toString(),
                          ),
                          _StatItem(
                            label: 'نشطة',
                            value: sessions.where((s) => s.status == 'inside').length.toString(),
                          ),
                          _StatItem(
                            label: 'منتهية',
                            value: sessions.where((s) => s.status == 'completed').length.toString(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'سجل الحضور',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                if (sessions.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'لا توجد جلسات حضور بعد',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: sessions.length,
                    itemBuilder: (context, index) {
                      final session = sessions[index];
                      return _SessionCard(session: session);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  final AttendanceSession session;

  const _SessionCard({required this.session});

  String _formatTime(DateTime dateTime) {
    return DateFormat('HH:mm', 'ar').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final hours = session.totalMinutes ~/ 60;
    final minutes = session.totalMinutes % 60;
    final durationText = hours > 0 ? '$hours س $minutes د' : '$minutes د';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: session.status == 'inside'
              ? Colors.green.withOpacity(0.2)
              : Colors.grey.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    session.sessionDate,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'دخول: ${_formatTime(session.checkInTime)}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              StatusBadge(
                label: session.status == 'inside' ? 'داخل' : 'منتهي',
                isActive: session.status == 'inside',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (session.checkOutTime != null)
                Text(
                  'خروج: ${_formatTime(session.checkOutTime!)}',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 14,
                  ),
                )
              else
                const Text(
                  'خروج: ---',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (session.checkOutTime != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    durationText,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
