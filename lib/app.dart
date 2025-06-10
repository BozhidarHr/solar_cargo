import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/providers/auth_provider.dart';
import 'package:solar_cargo/routes/routes.dart';
import 'package:solar_cargo/screens/home_screen.dart';
import 'package:solar_cargo/screens/login/view/login_screen.dart';

import 'generated/l10n.dart';

/// The Widget that configures your application.
class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(
    BuildContext context,
  ) {
    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return MaterialApp(
          // If not logged in and not on the login page, redirect to login

          home: _resolveInitialScreen(auth),
          onGenerateRoute: Routes.getRouteGenerate,
          // Otherwise, return the appropriate route

// Providing a restorationScopeId allows the Navigator built by the
// MaterialApp to restore the navigation stack when a user leaves and
// returns to the app after it has been killed while running in the
// background.
          restorationScopeId: 'app',

// Provide the generated AppLocalizations to the MaterialApp. This
// allows descendant Widgets to display the correct translations
// depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

// Use AppLocalizations to configure the correct application title
// depending on the user's locale.
//
// The appTitle is defined in .arb files found in the localization
// directory.
          onGenerateTitle: (BuildContext context) => S.of(context).appTitle,

// Define a light and dark color theme. Then, read the user's
// preferred ThemeMode (light, dark, or system default) from the
// SettingsController to display the correct theme.
          theme: ThemeData(
            primaryColor: const Color(0xFF6AB43E),
            scaffoldBackgroundColor: const Color(0xFF081C15),
            textTheme: const TextTheme(
              labelMedium: TextStyle(fontSize: 12),
              bodyMedium: TextStyle(fontSize: 14),
              titleMedium: TextStyle(fontSize: 16),
              displayMedium: TextStyle(fontSize: 18),
              headlineMedium: TextStyle(fontSize: 20),
            ),
            // Example primary color
          ),
          darkTheme: ThemeData.dark(),
          debugShowCheckedModeBanner: false,
// Define a function to handle named routes in order to support
// Flutter web url navigation and deep linking.
        );
      },
    );
  }

  Widget _resolveInitialScreen(AuthProvider auth) {
    if (!auth.isLoggedIn) return const LoginScreen();
    return const HomeScreen();
  }
}
