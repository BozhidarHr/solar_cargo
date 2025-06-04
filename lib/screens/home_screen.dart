import 'package:flutter/material.dart';

import '../routes/route_list.dart'; // Import the ViewReportsScreen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(
                RouteList.viewReports);
          },
          child: const Text('View Reports'),
        ),
      ),
    );
  }
}
