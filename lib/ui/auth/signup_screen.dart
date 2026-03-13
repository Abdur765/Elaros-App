import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/data/local/services/auth_service.dart';
import 'package:elaros_mobile_app/ui/home/wigets/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _conditionController = TextEditingController(text: 'Long Covid');
  final _restingHrController = TextEditingController();
  final _maxHrController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;
  int _currentStep = 0;

  final List<String> _conditions = [
    'Long Covid',
    'ME/CFS',
    'Fibromyalgia',
    'Dysautonomia',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _conditionController.dispose();
    _restingHrController.dispose();
    _maxHrController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final error = await AuthService.instance.signUp(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      condition: _conditionController.text.trim(),
      restingHr: int.parse(_restingHrController.text.trim()),
      maxHr: int.parse(_maxHrController.text.trim()),
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (error != null) {
      setState(() {
        _isLoading = false;
        _errorMessage = error;
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff9fafb),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xff111827)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Create Account",
            style: TextStyle(color: Color(0xff111827), fontWeight: FontWeight.w700)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step indicator
                Row(
                  children: [
                    _StepDot(label: "1", title: "Account", isActive: _currentStep == 0),
                    Expanded(child: Container(height: 2, color: _currentStep >= 1 ? const Color(0xff3b82f6) : const Color(0xffe5e7eb))),
                    _StepDot(label: "2", title: "Profile", isActive: _currentStep == 1),
                    Expanded(child: Container(height: 2, color: _currentStep >= 2 ? const Color(0xff3b82f6) : const Color(0xffe5e7eb))),
                    _StepDot(label: "3", title: "Health", isActive: _currentStep == 2),
                  ],
                ),
                const SizedBox(height: 24),

                if (_errorMessage != null) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xfffee2e2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xffef4444)),
                    ),
                    child: Text(_errorMessage!,
                        style: const TextStyle(color: Color(0xff991b1b), fontSize: 13)),
                  ),
                  const SizedBox(height: 16),
                ],

                // Step 0: Account details
                if (_currentStep == 0) ...[
                  const Text("Account Details",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff111827))),
                  const SizedBox(height: 8),
                  const Text("Enter your login credentials",
                      style: TextStyle(fontSize: 14, color: Color(0xff6b7280))),
                  const SizedBox(height: 24),
                  _buildField(_emailController, 'Email', Icons.email_outlined, keyboard: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      }),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xffe5e7eb))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xffe5e7eb))),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) return 'Minimum 6 characters';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildField(_confirmPasswordController, 'Confirm Password', Icons.lock_outlined,
                      obscure: true,
                      validator: (v) {
                        if (v != _passwordController.text) return 'Passwords do not match';
                        return null;
                      }),
                ],

                // Step 1: Personal info
                if (_currentStep == 1) ...[
                  const Text("Personal Information",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff111827))),
                  const SizedBox(height: 8),
                  const Text("Tell us about yourself",
                      style: TextStyle(fontSize: 14, color: Color(0xff6b7280))),
                  const SizedBox(height: 24),
                  _buildField(_nameController, 'Full Name', Icons.person_outlined,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null),
                  const SizedBox(height: 16),
                  _buildField(_ageController, 'Age', Icons.cake_outlined, keyboard: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Age is required';
                        final age = int.tryParse(v);
                        if (age == null || age < 10 || age > 120) return 'Enter a valid age';
                        return null;
                      }),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _conditionController.text,
                    decoration: InputDecoration(
                      labelText: 'Condition',
                      prefixIcon: const Icon(Icons.medical_information_outlined),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xffe5e7eb))),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xffe5e7eb))),
                    ),
                    items: _conditions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (v) => _conditionController.text = v ?? 'Long Covid',
                  ),
                ],

                // Step 2: Health baseline
                if (_currentStep == 2) ...[
                  const Text("Health Baseline",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff111827))),
                  const SizedBox(height: 8),
                  const Text("Used to calculate your personalised heart rate zones",
                      style: TextStyle(fontSize: 14, color: Color(0xff6b7280))),
                  const SizedBox(height: 24),
                  _buildField(_restingHrController, 'Resting Heart Rate (bpm)', Icons.favorite_border, keyboard: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Resting HR is required';
                        final hr = int.tryParse(v);
                        if (hr == null || hr < 30 || hr > 120) return 'Enter a valid resting HR (30-120)';
                        return null;
                      }),
                  const SizedBox(height: 8),
                  const Text("Your heart rate when completely at rest",
                      style: TextStyle(fontSize: 12, color: Color(0xff6b7280))),
                  const SizedBox(height: 16),
                  _buildField(_maxHrController, 'Maximum Heart Rate (bpm)', Icons.monitor_heart_outlined, keyboard: TextInputType.number,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Max HR is required';
                        final hr = int.tryParse(v);
                        if (hr == null || hr < 100 || hr > 220) return 'Enter a valid max HR (100-220)';
                        return null;
                      }),
                  const SizedBox(height: 8),
                  const Text("Adjusted maximum for your condition",
                      style: TextStyle(fontSize: 12, color: Color(0xff6b7280))),
                ],

                const SizedBox(height: 32),

                // Navigation buttons
                Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () => setState(() => _currentStep--),
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(color: Color(0xffe5e7eb)),
                            ),
                            child: const Text("Back", style: TextStyle(color: Color(0xff6b7280))),
                          ),
                        ),
                      ),
                    if (_currentStep > 0) const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isLoading
                              ? null
                              : () {
                                  if (_currentStep < 2) {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _currentStep++);
                                    }
                                  } else {
                                    _handleSignUp();
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff3b82f6),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(width: 20, height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(_currentStep < 2 ? "Next" : "Create Account",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                if (_currentStep == 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account? ",
                          style: TextStyle(color: Color(0xff6b7280), fontSize: 14)),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text("Sign In",
                            style: TextStyle(color: Color(0xff3b82f6), fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboard, String? Function(String?)? validator, bool obscure = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xffe5e7eb))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xffe5e7eb))),
      ),
      validator: validator,
    );
  }
}

class _StepDot extends StatelessWidget {
  final String label;
  final String title;
  final bool isActive;

  const _StepDot({required this.label, required this.title, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xff3b82f6) : const Color(0xffe5e7eb),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(label,
                style: TextStyle(color: isActive ? Colors.white : const Color(0xff6b7280),
                    fontWeight: FontWeight.w600, fontSize: 14)),
          ),
        ),
        const SizedBox(height: 4),
        Text(title,
            style: TextStyle(fontSize: 10,
                color: isActive ? const Color(0xff3b82f6) : const Color(0xff6b7280))),
      ],
    );
  }
}
