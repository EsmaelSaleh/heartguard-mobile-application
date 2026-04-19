import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';

class OnboardingMedicalHistoryScreen extends StatefulWidget {
  const OnboardingMedicalHistoryScreen({super.key});

  @override
  State<OnboardingMedicalHistoryScreen> createState() => _OnboardingMedicalHistoryScreenState();
}

class _OnboardingMedicalHistoryScreenState extends State<OnboardingMedicalHistoryScreen> {
  final List<String> _conditions = [];
  bool _familyHistory = false;

  void _toggleCondition(String condition) {
    setState(() {
      if (_conditions.contains(condition)) {
        _conditions.remove(condition);
      } else {
        _conditions.add(condition);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Medical History'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(value: 1.0, backgroundColor: Color(0xFFE2E8F0)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Health background',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Any existing conditions help us weigh your risk assessment correctly.',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Existing Conditions', LucideIcons.activity),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                'Hypertension',
                'Diabetes',
                'High Cholesterol',
                'Heart Arrhythmia',
                'Asthma',
                'None'
              ].map((c) => _buildChip(c)).toList(),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Family History', LucideIcons.users),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Family history of heart disease?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: const Text('Parents or siblings diagnosed before age 55', style: TextStyle(fontSize: 13)),
              value: _familyHistory,
              onChanged: (v) => setState(() => _familyHistory = v),
              activeColor: AppTheme.primary,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: () => context.pop(),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                      side: BorderSide(color: Colors.grey[200]!),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Back', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 56),
                    ),
                    child: const Text('Complete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildChip(String label) {
    final isSelected = _conditions.contains(label);
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _toggleCondition(label),
      selectedColor: AppTheme.primary.withOpacity(0.1),
      checkmarkColor: AppTheme.primary,
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primary : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isSelected ? AppTheme.primary : Colors.grey[300]!),
      ),
    );
  }
}
