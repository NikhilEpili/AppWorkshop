import 'package:flutter/material.dart';
import '../model/summary_model.dart';

class SummaryCard extends StatelessWidget {
  final Attendance attendance;
  final String status;
  final Color statusColor;

  const SummaryCard({
    super.key,
    required this.attendance,
    required this.status,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Summary',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: const Color(0xFFF9FAFB),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Large percentage display
          Center(
            child: Text(
              '${attendance.percentage.toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: const Color(0xFFF59E0B),
                fontWeight: FontWeight.bold,
                fontSize: 48,
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Mini cards row
          Row(
            children: [
              Expanded(
                child: _buildMiniCard(
                  context,
                  'Attended Lectures',
                  attendance.attendedLectures.toString(),
                  '✔️',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMiniCard(
                  context,
                  'Total Lectures',
                  attendance.totalLectures.toString(),
                  '📅',
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Status badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor, width: 1),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(BuildContext context, String title, String value, String icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                icon,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF9FAFB),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}