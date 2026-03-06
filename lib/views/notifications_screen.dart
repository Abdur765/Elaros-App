import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3F4F6),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: const [
                NotificationCard(
                  icon: Icons.error,
                  iconColor: Colors.red,
                  title: "High Intensity Detected",
                  message: "You are in the Risk Zone. Consider resting.",
                  time: "2 min ago",
                  cardColor: Color(0xFFFFE9E9),
                ),
                SizedBox(height: 12),
                NotificationCard(
                  icon: Icons.warning,
                  iconColor: Colors.orange,
                  title: "Recovery Low",
                  message: "Your HRV is below your baseline.",
                  time: "1 hour ago",
                  cardColor: Color(0xFFFFF4E5),
                ),
                SizedBox(height: 12),
                NotificationCard(
                  icon: Icons.info,
                  iconColor: Colors.blue,
                  title: "Inactivity Alert",
                  message: "Time to move a little and stretch.",
                  time: "3 hours ago",
                  cardColor: Color(0xFFE8F2FF),
                ),
                SizedBox(height: 12),
                NotificationCard(
                  icon: Icons.check_circle,
                  iconColor: Colors.green,
                  title: "All Clear",
                  message: "You are within safe levels.",
                  time: "Yesterday",
                  cardColor: Color(0xFFEAF7ED),
                ),
              ],
            ),
          ),

          // BUTTON TO ALERT PREFERENCES
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/preferences');
              },
              child: const Text("Alert Preferences"),
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String time;
  final Color cardColor;

  const NotificationCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.time,
    required this.cardColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_horiz, color: Colors.grey),
        ],
      ),
    );
  }
}
