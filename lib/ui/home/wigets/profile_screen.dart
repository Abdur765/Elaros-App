import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elaros_mobile_app/ui/home/view_models/health_view_model.dart';

const _bgColor = Color(0xfff9fafb);
const _cardBg = Colors.white;
const _textPrimary = Color(0xff111827);
const _textSecondary = Color(0xff6b7280);
const _border = Color(0xffe5e7eb);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  // Header - Red gradient
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xffef4444), Color(0xff991b1b)]),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Profile",
                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text("Manage your personal information",
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Profile card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: Column(
                        children: [
                          // Avatar
                          Container(
                            width: 64, height: 64,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(colors: [Color(0xffef4444), Color(0xffdc2626)]),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: Colors.white, size: 32),
                          ),
                          const SizedBox(height: 16),
                          const Text("User", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _textPrimary)),
                          const SizedBox(height: 4),
                          const Text("Health Tracker", style: TextStyle(fontSize: 14, color: _textSecondary)),
                          const SizedBox(height: 16),
                          Container(height: 1, color: _border),
                          const SizedBox(height: 16),
                          _InfoRow(label: "Resting HR", value: "${vm.minHR} bpm"),
                          const SizedBox(height: 12),
                          _InfoRow(label: "Max HR", value: "${vm.maxHR} bpm"),
                          const SizedBox(height: 12),
                          _InfoRow(label: "Avg HR", value: "${vm.avgHR} bpm"),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Health Baseline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("How Your Zones Are Calculated",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary)),
                          SizedBox(height: 12),
                          Text(
                            "Your heart rate zones are calculated using the Heart Rate Reserve (HRR) method, "
                            "which provides more personalized zones than simply using percentages of max HR.",
                            style: TextStyle(fontSize: 12, color: _textSecondary, height: 1.5),
                          ),
                          SizedBox(height: 12),
                          _FormulaBox(),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // About
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("About Elaros",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary)),
                          SizedBox(height: 12),
                          Text(
                            "Elaros helps people with energy-limiting conditions manage their daily activities "
                            "through heart rate zone monitoring and personalised insights.",
                            style: TextStyle(fontSize: 12, color: _textSecondary, height: 1.5),
                          ),
                          SizedBox(height: 8),
                          Text("Version 1.0.0", style: TextStyle(fontSize: 11, color: Color(0xff9ca3af))),
                        ],
                      ),
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
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: _textSecondary)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary)),
      ],
    );
  }
}

class _FormulaBox extends StatelessWidget {
  const _FormulaBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xfff3f4f6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        "Zone 1 (Recovery): 0-30% HRR\n"
        "Zone 2 (Sustainable): 30-50% HRR\n"
        "Zone 3 (Caution): 50-65% HRR\n"
        "Zone 4 (Risk): 65-80% HRR\n"
        "Zone 5 (Overexertion): 80-100% HRR",
        style: TextStyle(fontSize: 11, color: _textSecondary, fontFamily: 'monospace', height: 1.6),
      ),
    );
  }
}
