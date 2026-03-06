import 'package:flutter/material.dart';

class AlertPreferencesScreen extends StatefulWidget {
  const AlertPreferencesScreen({super.key});

  @override
  State<AlertPreferencesScreen> createState() => _AlertPreferencesScreenState();
}

class _AlertPreferencesScreenState extends State<AlertPreferencesScreen> {
  bool overexertion = true;
  bool hrvRecovery = true;
  bool inactivity = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Alert Preferences"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SwitchListTile(
              title: const Text("Overexertion Alerts"),
              subtitle: const Text("Alert when heart rate is too high"),
              value: overexertion,
              onChanged: (value) {
                setState(() {
                  overexertion = value;
                });
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text("HRV Recovery Alert"),
              subtitle: const Text("Notify when HRV is below normal"),
              value: hrvRecovery,
              onChanged: (value) {
                setState(() {
                  hrvRecovery = value;
                });
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text("Inactivity Reminder"),
              subtitle: const Text("Remind when sitting too long"),
              value: inactivity,
              onChanged: (value) {
                setState(() {
                  inactivity = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
