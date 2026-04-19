import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import '../theme.dart';
import '../widgets/app_drawer.dart';
import 'dart:math' as math;

class RiskReportScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  const RiskReportScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final vitals = data['vitals'] as Map<String, double>;
    const riskScore = 68; // Mock risk score for demo
    const riskLevel = 'moderate'; 

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Risk Assessment Report'),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft),
          onPressed: () => context.go('/dashboard'),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(LucideIcons.download)),
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: const Padding(
                padding: EdgeInsets.only(right: 16),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: AppTheme.primary,
                  child: Text('ES', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildReportHeader(),
            const SizedBox(height: 32),
            _buildRiskGauge(riskScore, riskLevel),
            const SizedBox(height: 32),
            _buildAiFindings(),
            const SizedBox(height: 32),
            _buildMetricBreakdown(vitals),
            const SizedBox(height: 32),
            _buildRecommendations(),
            const SizedBox(height: 48),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildReportHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Risk Assessment Report', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(LucideIcons.calendar, size: 14, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              'Generated on April 11, 2026 · ID: HG-8B3F11',
              style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRiskGauge(int score, String level) {
    final color = level == 'high' ? Colors.red : level == 'moderate' ? Colors.amber[700]! : Colors.green;
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          const Text('AI COMBINED RISK SCORE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1)),
          const SizedBox(height: 24),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CustomPaint(
                  painter: GaugePainter(score: score, color: color),
                ),
              ),
              Column(
                children: [
                  Text('$score%', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: color, height: 1)),
                  Text(level.toUpperCase(), style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildGaugeLabel('Low', Colors.green),
              _buildGaugeLabel('Moderate', Colors.amber[700]!),
              _buildGaugeLabel('High', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGaugeLabel(String label, Color color) {
    return Column(
      children: [
        Container(width: 40, height: 4, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[500])),
      ],
    );
  }

  Widget _buildAiFindings() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.brainCircuit, color: AppTheme.primary),
              SizedBox(width: 12),
              Text('AI Analysis Findings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('POWERED BY HEARTGUARD AI MODEL', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 0.5)),
          const SizedBox(height: 16),
          Text(
            'Your assessment shows a moderate cardiovascular risk profile. The primary drivers are elevated BMI and borderline cholesterol levels. Proactive lifestyle changes can meaningfully reduce your risk within 3-6 months.',
            style: TextStyle(color: Colors.grey[800], fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricBreakdown(Map<String, double> vitals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Metric Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildMetricCard('Cholesterol', '${vitals['cholesterol']?.toInt()} mg/dL', 'Borderline'),
            _buildMetricCard('BMI', '${vitals['bmi']}', 'Elevated'),
            _buildMetricCard('Heart Rate', '${vitals['heart_rate']?.toInt()} BPM', 'Normal'),
            _buildMetricCard('Glucose', '${vitals['glucose']?.toInt()} mg/dL', 'Normal'),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(String label, String value, String status) {
    final statusColor = status == 'Normal' ? Colors.green : status == 'Elevated' ? Colors.red : Colors.amber[700]!;

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
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(status.toUpperCase(), style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personalised Recommendations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildRecTile(LucideIcons.utensils, 'Diet Plan', 'Adopt a low-saturated-fat diet. Increase soluble fibre and omega-3s.', Colors.orange),
        _buildRecTile(LucideIcons.activity, 'Exercise', '150 min of moderate aerobic activity per week.', Colors.blue),
        _buildRecTile(LucideIcons.stethoscope, 'Medical', 'Schedule a follow-up with a cardiologist within 14 days.', Colors.red),
      ],
    );
  }

  Widget _buildRecTile(IconData icon, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.grey[800], fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => context.go('/chatbot'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
            backgroundColor: AppTheme.primary,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.messageSquare, color: Colors.white),
              SizedBox(width: 12),
              Text('Ask Heart Health AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => context.go('/dashboard'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Back to Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final int score;
  final Color color;

  GaugePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final basePaint = Paint()
      ..color = const Color(0xFFF1F5F9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      basePaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      (math.pi * 1.5) * (score / 100),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
