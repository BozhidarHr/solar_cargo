import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/providers/auth_provider.dart';
import 'package:solar_cargo/screens/create_report/viewmodel/create_report_view_model.dart';
import 'package:solar_cargo/screens/view_reports/viewmodel/view_reports_view_model.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize AuthProvider before runApp
  final authProvider = AuthProvider();
  await authProvider.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ViewReportsViewModel()),
        ChangeNotifierProvider(create: (_) => CreateReportViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}