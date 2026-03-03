import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/ui/home/view_models/health_view_model.dart';

const _bgColor = Color(0xfff9fafb);
const _cardBg = Colors.white;
const _textPrimary = Color(0xff111827);
const _textSecondary = Color(0xff6b7280);
const _border = Color(0xffe5e7eb);

class ZonesScreen extends StatelessWidget {
  const ZonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - Green gradient
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xff10b981), Color(0xff047857)]),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Activity Zones",
                        style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text("Understand your heart rate zones",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),

              // Introduction
              Padding(
                padding: const EdgeInsets.all(24),
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
                      Text("What are Activity Zones?",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textPrimary)),
                      SizedBox(height: 12),
                      Text(
                        "Activity zones help you understand how hard your body is working based on your heart rate. "
                        "For people with energy-limiting conditions like ME/CFS, Long COVID, or Fibromyalgia, "
                        "staying in safe zones is crucial for managing symptoms.",
                        style: TextStyle(fontSize: 12, color: _textSecondary, height: 1.5),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your personalized zones are calculated using your resting and maximum heart rates, "
                        "ensuring accurate guidance for your unique physiology.",
                        style: TextStyle(fontSize: 12, color: _textSecondary, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Your Personalized Zones
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text("Your Personalized Zones",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: _textPrimary)),
              ),
              const SizedBox(height: 12),

              ...hrZones.map((zone) => Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: zone.bgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: zone.color, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(color: zone.color, shape: BoxShape.circle),
                        child: Center(
                          child: Text("${zone.number}",
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(zone.name,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: zone.textColor)),
                            const SizedBox(height: 4),
                            Text(zone.description,
                                style: TextStyle(fontSize: 12, color: zone.textColor)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }
}
