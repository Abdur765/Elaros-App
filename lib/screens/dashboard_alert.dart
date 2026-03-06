import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(child: Text("High Intensity Detected")),
                  Icon(Icons.close),
                ],
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.red),
              title: Text("Heart Rate"),
              trailing: Text("145 bpm"),
            ),
            ListTile(
              leading: Icon(Icons.show_chart, color: Colors.blue),
              title: Text("HRV"),
              trailing: Text("32 ms"),
            ),
            ListTile(
              leading: Icon(Icons.local_fire_department, color: Colors.orange),
              title: Text("Calories"),
              trailing: Text("450 kcal"),
            ),
          ],
        ),
      ),
    );
  }
}
