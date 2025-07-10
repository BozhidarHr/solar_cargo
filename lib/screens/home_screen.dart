import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_cargo/providers/auth_provider.dart';
import 'package:solar_cargo/screens/choose_location_screen.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';

import '../routes/route_list.dart';
import 'common/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    // Redirect to login if not logged in
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteList.login,
          (route) => false,
        );
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 40,
          child: Image.asset(
            kLogoImage,
            fit: BoxFit.contain,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome Back!",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: 16,
                            ),
                      ),
                      if (user.userName.isNotEmpty)
                        Text(
                          user.userName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.white),
                        ),
                      if (user.currentLocation != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          "Location:",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 16),
                        ),
                        Text(
                          user.currentLocation!.name,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(color: Colors.white),
                        )
                      ]
                    ],
                  ),
                ),
                Column(
                  children: [
                    Image.asset(
                      kWorkerImage,
                      width: 60,
                      height: 60,
                    ),
                    if (user.userRole.isNotNullAndNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.userRole!.upperCaseFirstChar(),
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0.5,
                                  ),
                        ),
                      )
                  ],
                ),
              ],
            ),

            const Spacer(),

            // Centered main content
            Column(
              children: [
                const Text(
                  'Welcome to the Dashboard',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                _buildButton(
                  context: context,
                  label: 'New Report',
                  icon: Icons.add_chart,
                  onPressed: () {
                    Navigator.of(context).pushNamed(RouteList.createReport);
                  },
                ),
                const SizedBox(height: 16),
                  _buildButton(
                    context: context,
                    label: 'View Reports',
                    icon: Icons.list_alt,
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouteList.viewReports);
                    },
                  ),
                  const SizedBox(height: 16),
                if (user.locations.length > 1) ...[
                  _buildButton(
                    context: context,
                    label: 'Change Location',
                    icon: Icons.location_city,
                    onPressed: () {
                      Navigator.of(context).pushNamed(RouteList.chooseLocation,
                          arguments: ChooseLocationScreenArguments(user));
                    },
                  ),
                  const SizedBox(height: 16),
                ],
                _buildButton(
                  context: context,
                  label: 'Logout',
                  icon: Icons.logout,
                  onPressed: () {
                    authProvider.logout();
                  },
                ),
              ],
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
