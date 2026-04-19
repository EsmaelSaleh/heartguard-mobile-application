import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';
import '../models/health_metric.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _hasAssessment = true; // Set to true for demo purpose
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF8FAFC),
      drawer: const AppDrawer(),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWelcomeHeader(),
            const SizedBox(height: 24),
            _buildQuickActions(),
            const SizedBox(height: 32),
            if (!_hasAssessment) _buildEmptyState(),
            if (_hasAssessment) ...[
              _buildRiskSummarySection(),
              const SizedBox(height: 32),
              _buildMetricsGrid(),
              const SizedBox(height: 32),
              _buildTrendChart(),
            ],
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(LucideIcons.chevronLeft, color: AppTheme.primary),
        onPressed: () => context.go('/'),
      ),
      title: Row(
        children: [
          Image.network('https://raw.githubusercontent.com/EsmaelSaleh/heartguard-app/main/src/assets/logo.png', width: 28, height: 28, errorBuilder: (_, __, ___) => const Icon(LucideIcons.heartPulse, color: AppTheme.primary)),
          const SizedBox(width: 8),
          const Text('HeartGuard', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          child: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primary,
              child: Text('ES', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome back, Esmael', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(
          _hasAssessment ? 'Last assessment: April 11, 2026' : 'Complete your first assessment to see insights.',
          style: TextStyle(color: Colors.grey[600], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => context.push('/assessment/vitals'),
              icon: const Icon(LucideIcons.refreshCw, size: 16, color: Colors.white),
              label: const Text('New Assessment', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => context.go('/chatbot'),
              icon: const Icon(LucideIcons.bot, size: 16),
              label: const Text('Ask AI'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.05), shape: BoxShape.circle),
            child: const Icon(LucideIcons.activity, size: 48, color: AppTheme.primary),
          ),
          const SizedBox(height: 24),
          const Text('No Health Data Yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text(
            'Complete your baseline assessment to unlock personalized AI-powered analysis.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskSummarySection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('HEART HEALTH RISK', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
              Icon(LucideIcons.info, size: 16, color: Colors.grey[400]),
            ],
          ),
          const SizedBox(height: 24),
          _buildGauge(68, 'MODERATE', Colors.amber[700]!),
        ],
      ),
    );
  }

  Widget _buildGauge(int score, String label, Color color) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: CustomPaint(
                painter: DashboardGaugePainter(score: score, color: color),
              ),
            ),
            Column(
              children: [
                Text('$score', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: color, height: 1)),
                Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Score improved by 4 points since last assessment.',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Latest Test Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _buildMetricCard(HealthMetric(label: 'Cholesterol', value: '210', unit: 'mg/dL', status: 'Borderline', riskLevel: RiskLevel.moderate)),
            _buildMetricCard(HealthMetric(label: 'BMI', value: '28.4', unit: 'kg/m²', status: 'Overweight', riskLevel: RiskLevel.high)),
            _buildMetricCard(HealthMetric(label: 'Heart Rate', value: '72', unit: 'BPM', status: 'Normal', riskLevel: RiskLevel.low)),
            _buildMetricCard(HealthMetric(label: 'Glucose', value: '95', unit: 'mg/dL', status: 'Normal', riskLevel: RiskLevel.low)),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(HealthMetric metric) {
    final statusColor = metric.riskLevel == RiskLevel.low 
        ? Colors.green 
        : metric.riskLevel == RiskLevel.moderate 
            ? Colors.amber[700]! 
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(metric.label.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
          const Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(metric.value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
              const SizedBox(width: 4),
              Text(metric.unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(metric.status.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Risk Score Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Tracking your points across last 6 assessments', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          const SizedBox(height: 32),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 75),
                      FlSpot(1, 72),
                      FlSpot(2, 78),
                      FlSpot(3, 70),
                      FlSpot(4, 68),
                    ],
                    isCurved: true,
                    color: AppTheme.primary,
                    barWidth: 4,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primary.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => context.push('/risk-report', extra: {'vitals': {'cholesterol': 210.0, 'bmi': 28.4, 'heart_rate': 72.0, 'glucose': 95.0, 'pulse_pressure': 40.0}}),
              icon: const Icon(LucideIcons.barChart2, size: 16),
              label: const Text('View Full Report', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardGaugePainter extends CustomPainter {
  final int score;
  final Color color;

  DashboardGaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final basePaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      basePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi * (score / 100),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
