import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/data/local/services/auth_service.dart';
import 'package:elaros_mobile_app/data/local/services/database_helper.dart';
import 'package:elaros_mobile_app/data/local/model/user_profile.dart';
import 'package:elaros_mobile_app/data/local/model/activity_zone.dart';
import 'package:elaros_mobile_app/data/local/model/fitness_goal.dart';
import 'package:elaros_mobile_app/ui/auth/login_screen.dart';

const _bgColor = Color(0xfff9fafb);
const _cardBg = Colors.white;
const _textPrimary = Color(0xff111827);
const _textSecondary = Color(0xff6b7280);
const _border = Color(0xffe5e7eb);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isEditing = false;
  bool isLoading = true;

  UserProfile? _profile;
  List<ActivityZone> _zones = [];
  List<FitnessGoal> _goals = [];

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _conditionController = TextEditingController();
  final _restingController = TextEditingController();
  final _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userId = AuthService.instance.currentUserId;
    if (userId == null) return;

    final profile = await DatabaseHelper.instance.getUserProfile(userId);
    final zones = await DatabaseHelper.instance.getActivityZonesForUser(userId);
    final goals = await DatabaseHelper.instance.getFitnessGoalsForUser(userId);

    if (!mounted) return;
    setState(() {
      _profile = profile;
      _zones = zones;
      _goals = goals;
      isLoading = false;

      if (profile != null) {
        _nameController.text = profile.name;
        _ageController.text = profile.age.toString();
        _conditionController.text = profile.condition;
        _restingController.text = profile.restingHr.toString();
        _maxController.text = profile.maxHr.toString();
      }
    });
  }

  Future<void> _saveProfile() async {
    if (_profile == null) return;

    final age = int.tryParse(_ageController.text.trim());
    final rhr = int.tryParse(_restingController.text.trim());
    final mhr = int.tryParse(_maxController.text.trim());

    if (age == null || rhr == null || mhr == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Only numeric values allowed for age and heart rates")),
      );
      return;
    }

    final updated = _profile!.copyWith(
      name: _nameController.text.trim(),
      age: age,
      condition: _conditionController.text.trim(),
      restingHr: rhr,
      maxHr: mhr,
    );

    await DatabaseHelper.instance.updateUserProfile(updated);

    // Also update HealthBaseline
    final db = await DatabaseHelper.instance.database;
    await db.delete('HealthBaseline', where: 'name = ?', whereArgs: [_profile!.name]);
    await db.insert('HealthBaseline', {
      'name': updated.name,
      'age': updated.age,
      'condition': updated.condition,
      'RHR': updated.restingHr,
      'MHR': updated.maxHr,
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile Updated Successfully")),
    );
    _loadProfile();
  }

  void _toggleEditSave() async {
    if (isEditing) {
      await _saveProfile();
    }
    setState(() => isEditing = !isEditing);
  }

  Future<void> _logout() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _conditionController.dispose();
    _restingController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: _bgColor,
        body: Center(child: CircularProgressIndicator(color: Color(0xff3b82f6))),
      );
    }

    return Scaffold(
      backgroundColor: _bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xffef4444), Color(0xff991b1b)]),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Profile",
                            style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
                        SizedBox(height: 4),
                        Text("Manage your personal information",
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                      ],
                    ),
                    IconButton(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout, color: Colors.white),
                      tooltip: 'Sign Out',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Profile Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xffef4444), Color(0xffdc2626)]),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person, color: Colors.white, size: 30),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_nameController.text,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _textPrimary)),
                            Text("${_ageController.text} years old",
                                style: const TextStyle(color: _textSecondary)),
                            const SizedBox(height: 4),
                            Text("Condition: ${_conditionController.text}",
                                style: const TextStyle(color: _textSecondary, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Health Baseline Section
              _sectionTitleWithButton("Health Baseline"),
              _buildCard([
                _buildField("Name", _nameController, false),
                _buildField("Age", _ageController, true),
                _buildField("Condition", _conditionController, false),
                _buildField("Resting Heart Rate (bpm)", _restingController, true),
                const Text("Your heart rate when completely at rest",
                    style: TextStyle(fontSize: 12, color: _textSecondary)),
                const SizedBox(height: 10),
                _buildField("Maximum Heart Rate (bpm)", _maxController, true),
                const Text("Adjusted maximum for your condition",
                    style: TextStyle(fontSize: 12, color: _textSecondary)),
              ]),

              const SizedBox(height: 20),

              // Goals Section
              _buildSectionTitle("Your Goals"),
              _buildCard(
                _goals.isNotEmpty
                    ? _goals.map((g) => _goalItem(
                        "${g.goalType.replaceAll('_', ' ')} - ${g.currentValue.toStringAsFixed(0)}/${g.targetValue.toStringAsFixed(0)} ${g.unit}",
                        g.isCompleted,
                      )).toList()
                    : [
                        _goalItem("Improve pacing", false),
                        _goalItem("Reduce PEM episodes", false),
                        _goalItem("Track recovery", false),
                      ],
              ),

              const SizedBox(height: 20),

              // Zones explanation
              _buildSectionTitle("How Your Zones Are Calculated"),
              _buildCard([
                if (_zones.isNotEmpty)
                  ..._zones.map((z) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      "Zone ${z.zoneNumber} (${z.zoneName}): ${z.hrLower}-${z.hrUpper} bpm",
                      style: const TextStyle(fontSize: 13, color: _textSecondary, fontFamily: 'monospace'),
                    ),
                  ))
                else
                  const Text(
                    "Zone 1 (Recovery): 0-30% HRR\n"
                    "Zone 2 (Sustainable): 30-50% HRR\n"
                    "Zone 3 (Caution): 50-65% HRR\n"
                    "Zone 4 (Risk): 65-80% HRR\n"
                    "Zone 5 (Overexertion): 80-100% HRR",
                    style: TextStyle(fontSize: 12, color: _textSecondary, fontFamily: 'monospace', height: 1.6),
                  ),
                const SizedBox(height: 8),
                const Text(
                  "These percentages are adapted to be conservative and safe for energy-limiting conditions.",
                  style: TextStyle(color: _textSecondary, fontSize: 12),
                ),
              ]),

              const SizedBox(height: 20),

              // Data & Privacy
              _buildSectionTitle("Data & Privacy"),
              _buildCard([
                const Text(
                  "All your health data is stored locally on your device. No data is sent to external servers.",
                  style: TextStyle(color: _textSecondary, fontSize: 12),
                ),
              ]),

              const SizedBox(height: 20),

              // About
              _buildSectionTitle("About Elaros"),
              _buildCard([
                const Text(
                  "Elaros is designed to help individuals with energy-limiting "
                  "conditions such as ME/CFS, Long COVID, and Fibromyalgia "
                  "better understand and manage their activity levels.\n\n"
                  "Version 1.0.0\nBuilt with care for the chronic illness community.",
                  style: TextStyle(color: _textSecondary, fontSize: 12),
                ),
              ]),

              const SizedBox(height: 96),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitleWithButton(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textPrimary)),
          TextButton(
            onPressed: _toggleEditSave,
            child: Text(isEditing ? "Save" : "Edit",
                style: const TextStyle(color: Color(0xff3b82f6), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _textPrimary)),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, bool isNumber) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: _textPrimary)),
          const SizedBox(height: 5),
          TextField(
            controller: controller,
            enabled: isEditing,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
              filled: true,
              fillColor: isEditing ? Colors.white : const Color(0xfff3f4f6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isEditing ? const Color(0xff3b82f6) : _border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: _border),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _goalItem(String text, bool completed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_circle : Icons.radio_button_unchecked,
            color: completed ? const Color(0xff10b981) : const Color(0xff3b82f6),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: _textPrimary, fontSize: 13))),
        ],
      ),
    );
  }
}
