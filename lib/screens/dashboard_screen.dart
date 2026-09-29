import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/employee.dart';
import '../providers/attendance_provider.dart';
import '../widgets/employee_avatar.dart';
import '../widgets/stat_card.dart';
import 'attendance_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ValueNotifier<String> _searchText = ValueNotifier('');

  @override
  void dispose() {
    _searchText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AttendanceProvider>();
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE dd MMMM yyyy', 'ar').format(now);
    final formattedTime = DateFormat('HH:mm', 'ar').format(now);

    final filteredEmployees = provider.employees.where((employee) {
      final query = _searchText.value.trim();
      if (query.isEmpty) return true;
      return employee.fullName.contains(query) || employee.role.contains(query);
    }).toList();

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لوحة المتوظفين'),
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('لا توجد إخطارات جديدة'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await provider.loadEmployees();
            await provider.refreshSummary();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Date and Time Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFB71C1C),
                        const Color(0xFFB71C1C).withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formattedTime,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'الدوام',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatCard(
                            title: 'متوا',
                            value: provider.summary['inside'] ?? 0,
                            color: Colors.green,
                          ),
                          StatCard(
                            title: 'متأخ',
                            value: provider.summary['late'] ?? 0,
                            color: Colors.orange,
                          ),
                          StatCard(
                            title: 'غائب',
                            value: provider.summary['absent'] ?? 0,
                            color: Colors.red,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    textAlign: TextAlign.right,
                    onChanged: (value) => _searchText.value = value,
                    decoration: InputDecoration(
                      hintText: 'بحث عن موظف',
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                // Employees List
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الموظفين (${filteredEmployees.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (filteredEmployees.isEmpty)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'لم يتم العثور على نتائج',
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
                          itemCount: filteredEmployees.length,
                          itemBuilder: (context, index) {
                            final employee = filteredEmployees[index];
                            return FutureBuilder<bool>(
                              future: provider.isCheckedIn(employee),
                              builder: (context, snapshot) {
                                final isCheckedIn = snapshot.data ?? false;
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            AttendanceDetailScreen(employee: employee),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        EmployeeAvatar(
                                          initials: employee.initials,
                                          accentColorValue: employee.accentColorValue,
                                          radius: 28,
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                employee.fullName,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                employee.role,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        GestureDetector(
                                          onTap: () async {
                                            await provider
                                                .toggleAttendance(employee);
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isCheckedIn
                                                  ? Colors.green
                                                  : const Color(0xFFB71C1C),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              isCheckedIn ? 'خروج' : 'دخول',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
