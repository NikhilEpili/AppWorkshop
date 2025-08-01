import 'package:flutter/material.dart';
import '../controller/attendance_controller.dart';
import '../model/subject_model.dart';
import '../../../theme.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  late AttendanceController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AttendanceController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppSprint'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return RefreshIndicator(
            onRefresh: _controller.refreshData,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _controller.subjects.length,
              itemBuilder: (context, index) {
                final subject = _controller.subjects[index];
                return _buildSubjectCard(subject);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubjectModal,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          // TODO: Implement navigation to other pages
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Timetable',
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(Subject subject) {
    final attendancePercentage = subject.attendancePercentage;
    final meetsThreshold = subject.meetsThreshold(_controller.minimumThreshold);
    
    return Card(
      elevation: 3,
      shadowColor: const Color(0x1A000000),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: meetsThreshold ? 
              [
                AppTheme.successColor.withValues(alpha: 0.05),
                AppTheme.successColor.withValues(alpha: 0.02),
              ] : 
              [
                AppTheme.dangerColor.withValues(alpha: 0.05),
                AppTheme.dangerColor.withValues(alpha: 0.02),
              ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      subject.name,
                      style: AppTheme.headingSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'delete') {
                        _showDeleteConfirmation(subject);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: AppTheme.dangerColor),
                            SizedBox(width: 8),
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: meetsThreshold ? 
                        AppTheme.successColor.withValues(alpha: 0.1) : 
                        AppTheme.dangerColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: meetsThreshold ? 
                          AppTheme.successColor.withValues(alpha: 0.3) : 
                          AppTheme.dangerColor.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${attendancePercentage.toStringAsFixed(1)}%',
                      style: AppTheme.bodyMedium.copyWith(
                        color: meetsThreshold ? AppTheme.successColor : AppTheme.dangerColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${subject.attendedLectures}/${subject.totalLectures} lectures',
                      style: AppTheme.bodyMedium.copyWith(
                        color: const Color(0xFF7F8C8D),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.markPresent(subject.id),
                      icon: const Icon(Icons.check, color: Colors.white, size: 18),
                      label: const Text('Present'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.successColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppTheme.successColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _controller.markAbsent(subject.id),
                      icon: const Icon(Icons.close, color: Colors.white, size: 18),
                      label: const Text('Absent'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.dangerColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: AppTheme.dangerColor.withValues(alpha: 0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    double tempThreshold = _controller.minimumThreshold;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Minimum Attendance Threshold'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.accentColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${tempThreshold.toStringAsFixed(0)}%',
                  style: AppTheme.headingMedium.copyWith(
                    color: AppTheme.accentColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.accentColor,
                  inactiveTrackColor: AppTheme.accentColor.withValues(alpha: 0.2),
                  thumbColor: AppTheme.accentColor,
                  overlayColor: AppTheme.accentColor.withValues(alpha: 0.1),
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
                ),
                child: Slider(
                  value: tempThreshold,
                  min: 0,
                  max: 100,
                  divisions: 20,
                  onChanged: (value) {
                    setDialogState(() {
                      tempThreshold = value;
                    });
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _controller.updateThreshold(tempThreshold);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Threshold updated successfully'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSubjectModal() {
    final nameController = TextEditingController();
    final attendedController = TextEditingController();
    final totalController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add New Subject',
                  style: AppTheme.headingMedium,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Subject Name',
                    hintText: 'Enter subject name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter subject name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: attendedController,
                  decoration: const InputDecoration(
                    labelText: 'Attended Lectures',
                    hintText: 'Enter attended lectures',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter attended lectures';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 0) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: totalController,
                  decoration: const InputDecoration(
                    labelText: 'Total Lectures',
                    hintText: 'Enter total lectures',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter total lectures';
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null || intValue < 1) {
                      return 'Total lectures must be at least 1';
                    }
                    final attendedValue = int.tryParse(attendedController.text) ?? 0;
                    if (intValue < attendedValue) {
                      return 'Total lectures cannot be less than attended';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        _controller.addSubject(
                          nameController.text.trim(),
                          int.parse(attendedController.text),
                          int.parse(totalController.text),
                        );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Subject added successfully'),
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      }
                    },
                    child: const Text('Save Subject'),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Subject subject) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Subject'),
        content: Text('Are you sure you want to delete "${subject.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              _controller.deleteSubject(subject.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Subject deleted successfully'),
                  backgroundColor: AppTheme.dangerColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.dangerColor,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}