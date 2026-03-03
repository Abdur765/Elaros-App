import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:elaros_mobile_app/ui/common/widgets/bottom_navbar.dart';
import 'package:elaros_mobile_app/ui/home/view_models/health_view_model.dart';
import 'package:elaros_mobile_app/ui/home/wigets/Home_Page.dart';
import 'package:elaros_mobile_app/ui/home/wigets/insights_screen.dart';
import 'package:elaros_mobile_app/ui/home/wigets/zones_screen.dart';
import 'package:elaros_mobile_app/ui/home/wigets/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<HealthViewModel>().loadAllData();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return const DashboardScreen();
      case 1:
        return const InsightsScreen();
      case 2:
        return const ZonesScreen();
      case 3:
        return const ProfileScreen();
      default:
        return const DashboardScreen();
    }
  }
}
