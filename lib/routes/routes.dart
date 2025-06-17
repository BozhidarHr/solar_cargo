import 'package:flutter/material.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
import 'package:solar_cargo/screens/home_screen.dart';
import 'package:solar_cargo/screens/login/view/login_screen.dart';
import 'package:solar_cargo/screens/view_reports/view/view_report_detail.dart';

import '../screens/create_report/view/create_report_stepper.dart';
import '../screens/view_reports/view/view_reports_screen.dart';
import '../widgets/error_widget.dart';
import 'route_list.dart';

class Routes {
  static Route getRouteGenerate(RouteSettings settings) {
    var routingData = settings.name!.getRoutingData;

    switch (routingData.route) {
      case RouteList.home:
        return _buildRoute(
          settings,
              (context) => const HomeScreen(),
        );
      case RouteList.login:
        return _buildRoute(
          settings,
          (context) => const LoginScreen(),
        );
      case RouteList.reportDetails:
          return _buildRoute(
            settings,
                (context) => ViewReportDetail(),
          );

      case RouteList.viewReports:
        return _buildRoute(
          settings,
          (context) => const ViewReportsScreen(),
        );
      case RouteList.createReport:
        return _buildRoute(
          settings,
              (context) =>  const CreateReportStepper(),
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
