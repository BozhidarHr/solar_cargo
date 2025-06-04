import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import '../routes/route_list.dart';
import 'common/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: Image.asset(
            kLogo,
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Icon(Icons.analytics, size: 80, color: HexColor(kPrimaryGreenColor)),
            const SizedBox(height: 24),
            const Text(
              'Welcome to the Dashboard',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteList.viewReports);
                },
                icon: const Icon(Icons.bar_chart),
                label: const Text('View Reports'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor(kPrimaryGreenColor),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(RouteList.login);
                },
                icon: const Icon(Icons.bar_chart),
                label: const Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HexColor(kPrimaryGreenColor),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
