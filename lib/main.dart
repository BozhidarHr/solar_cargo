import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/providers/auth_provider.dart';
import 'package:solar_cargo/screens/create_report/viewmodel/create_report_view_model.dart';
import 'package:solar_cargo/screens/view_reports/viewmodel/view_reports_view_model.dart';

import 'app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        ChangeNotifierProvider(create: (_) => ViewReportsViewModel()),
        ChangeNotifierProvider(create: (_) => CreateReportViewModel()),

      ],
      child: const MyApp(),
    ),
  );
}
