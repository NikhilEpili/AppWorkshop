import 'package:flutter/material.dart';

class ThresholdDialog extends StatefulWidget {
  final double currentThreshold;
  final Function(double) onThresholdChanged;

  const ThresholdDialog({
    super.key,
    required this.currentThreshold,
    required this.onThresholdChanged,
  });

  @override
  State<ThresholdDialog> createState() => _ThresholdDialogState();
}

class _ThresholdDialogState extends State<ThresholdDialog> {
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.currentThreshold;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1F2937),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text(
        'Set Attendance Threshold',
        style: TextStyle(
          color: Color(0xFFF9FAFB),
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Current threshold: ${_currentValue.toInt()}%',
            style: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          
          // Progress indicator showing current value
          LinearProgressIndicator(
            value: _currentValue / 100,
            backgroundColor: const Color(0xFF374151),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFF59E0B)),
            minHeight: 8,
          ),
          
          const SizedBox(height: 20),
          
          // Slider for adjusting threshold
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFFF59E0B),
              inactiveTrackColor: const Color(0xFF374151),
              thumbColor: const Color(0xFFF59E0B),
              overlayColor: const Color(0xFFF59E0B).withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              trackHeight: 4,
            ),
            child: Slider(
              value: _currentValue,
              min: 0,
              max: 100,
              divisions: 20,
              label: '${_currentValue.toInt()}%',
              onChanged: (value) {
                setState(() {
                  _currentValue = value;
                });
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Color(0xFF9CA3AF)),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onThresholdChanged(_currentValue);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF59E0B),
            foregroundColor: const Color(0xFF111827),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
