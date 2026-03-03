import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elaros_mobile_app/ui/home/view_models/health_view_model.dart';
import 'package:elaros_mobile_app/ui/core/graphs/line_chart.dart' as custom;
import 'package:elaros_mobile_app/ui/core/graphs/base_chart.dart';

const _bgColor = Color(0xfff9fafb);
const _cardBg = Colors.white;
const _textPrimary = Color(0xff111827);
const _textSecondary = Color(0xff6b7280);
const _border = Color(0xffe5e7eb);

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HealthViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: _bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header - Purple gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffa855f7), Color(0xff6b21a8)]),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Insights",
                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text("Track your trends and progress",
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Weekly Summary
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text("Weekly Summary",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textPrimary)),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        _SummaryCard(icon: Icons.directions_walk, iconColor: const Color(0xff3b82f6),
                            label: "Steps", value: vm.formatNumber(vm.todaySteps)),
                        const SizedBox(width: 12),
                        _SummaryCard(icon: Icons.favorite, iconColor: const Color(0xffef4444),
                            label: "Avg HR", value: "${vm.avgHR} bpm"),
                        const SizedBox(width: 12),
                        _SummaryCard(icon: Icons.local_fire_department, iconColor: const Color(0xff10b981),
                            label: "Calories", value: vm.todayCalories.toStringAsFixed(0)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Heart Rate Trend
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildTrendCard(
                      title: "Heart Rate Trend",
                      lineColor: const Color(0xffef4444),
                      child: vm.hourlyHeartRate.isNotEmpty
                          ? SizedBox(
                              height: 200,
                              child: custom.LineChart(
                                data: vm.hourlyHeartRate,
                                mappingKeyX: 'hour',
                                mappingKeyY: 'avgHR',
                                darkTheme: false,
                                xAxisTitle: 'Hour',
                                yAxisTitle: 'bpm',
                                legendPosition: null,
                              ),
                            )
                          : _noData(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Steps Trend
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildTrendCard(
                      title: "Daily Steps Trend",
                      lineColor: const Color(0xff10b981),
                      child: vm.dailySteps.isNotEmpty
                          ? SizedBox(
                              height: 200,
                              child: custom.LineChart(
                                data: vm.dailySteps,
                                mappingKeyX: 'date',
                                mappingKeyY: 'steps',
                                darkTheme: false,
                                xAxisTitle: 'Date',
                                yAxisTitle: 'Steps',
                                xScaleType: ScaleType.ordinal,
                                legendPosition: null,
                              ),
                            )
                          : _noData(),
                    ),
                  ),

                  const SizedBox(height: 96),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrendCard({required String title, required Color lineColor, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _noData() {
    return const SizedBox(
      height: 60,
      child: Center(child: Text('No data available', style: TextStyle(color: _textSecondary, fontSize: 12))),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryCard({required this.icon, required this.iconColor, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, color: _textSecondary)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary)),
          ],
        ),
      ),
    );
  }
}
