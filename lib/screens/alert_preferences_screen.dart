import 'package:flutter/material.dart';

class AlertPreferencesScreen extends StatefulWidget {
  const AlertPreferencesScreen({super.key});

  @override
  State<AlertPreferencesScreen> createState() => _AlertPreferencesScreenState();
}

class _AlertPreferencesScreenState extends State<AlertPreferencesScreen> {
  bool overexertion = true;
  bool hrvRecovery = true;
  bool inactivityReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alert Preferences"),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Overexertion Alerts"),
            value: overexertion,
            onChanged: (value) {
              setState(() {
                overexertion = value;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("HRV Recovery Alerts"),
            value: hrvRecovery,
            onChanged: (value) {
              setState(() {
                hrvRecovery = value;
              });
            },
          ),
          const Divider(),
          SwitchListTile(
            title: const Text("Inactivity Reminders"),
            value: inactivityReminder,
            onChanged: (value) {
              setState(() {
                inactivityReminder = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
