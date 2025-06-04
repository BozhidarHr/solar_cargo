import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
import 'package:solar_cargo/screens/login/view/login_screen.dart';
import 'package:solar_cargo/screens/main_screen.dart';

import '../screens/home_screen.dart';
import '../screens/tesseract_ocr_screen.dart';
import '../screens/view_reports/view/view_reports_screen.dart';
import '../widgets/error_widget.dart';
import 'route_list.dart';

class Routes {
  static Map<String, WidgetBuilder> getAll() => _routes;

  static final Map<String, WidgetBuilder> _routes = {
    RouteList.home: (context) => const HomeScreen(),
    RouteList.mainScreen: (context) => const MainScreen(),
    RouteList.tesseract: (context) => TesseractOCRScreen(),
    RouteList.login: (context) => LoginScreen(),
    RouteList.viewReports: (context) {
      return const ViewReportsScreen();
    }
  };

  static Route getRouteGenerate(RouteSettings settings) {
    var routingData = settings.name!.getRoutingData;

    switch (routingData.route) {
      case RouteList.viewReports:
        return _buildRoute(
          settings,
          (context) => const ViewReportsScreen(),
        );
    }
    return _errorRoute();
  }

  static MaterialPageRoute _buildRoute(
      RouteSettings settings, WidgetBuilder builder,
      {bool fullscreenDialog = false}) {
    return MaterialPageRoute(
      settings: settings,
      builder: builder,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Route _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
        ),
        body: const ErrorWidgetCustom(),
      );
    });
  }
}

class RoutingData {
  final String? route;
  final Map<String, String>? _queryParameters;

  RoutingData({
    this.route,
    Map<String, String>? queryParameters,
  }) : _queryParameters = queryParameters;

  String? getPram(String key) => _queryParameters![key];
}
