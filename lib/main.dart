import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:elaros_mobile_app/app.dart';
import 'package:provider/provider.dart';
import 'package:elaros_mobile_app/ui/home/view_models/health_view_model.dart';
import 'package:elaros_mobile_app/data/local/services/auth_service.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Initialize auth state from saved session
  await AuthService.instance.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => HealthViewModel(),
      child: const App(),
    ),
  );
}
