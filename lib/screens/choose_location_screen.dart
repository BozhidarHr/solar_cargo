import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'common/flash_helper.dart';
import 'common/user_location.dart';
import 'home_screen.dart';

class ChooseLocationScreenArguments {
  final User user;

  ChooseLocationScreenArguments(this.user);
}

class ChooseLocationScreen extends StatefulWidget {
  final User user;

  const ChooseLocationScreen({
    super.key,
    required this.user,
  });

  @override
  ChooseLocationScreenState createState() => ChooseLocationScreenState();
}

class ChooseLocationScreenState extends State<ChooseLocationScreen> {
  UserLocation? selectedItem;

  @override
  Widget build(BuildContext context) {
    final List<UserLocation> locations = widget.user.locations;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (locations.isEmpty)
              Center(
                child: Column(
                  children: [
                    const Text(
                      'No locations available.\nPlease contact your administrator.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.redAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          authProvider.logout();
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
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
                    ),
                  ],
                ),
              )
            else ...[
              const Text(
                'Select Location',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              DropdownButton2<UserLocation>(
                isExpanded: true,
                dropdownStyleData: DropdownStyleData(
                  decoration: BoxDecoration(
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  offset: const Offset(0, 0),
                ),
                hint: const Text(
                  'Select location',
                  style: TextStyle(color: Colors.white),
                ),
                items: locations.map((UserLocation value) {
                  return DropdownMenuItem<UserLocation>(
                    value: value,
                    child: Text(
                      value.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
                value: selectedItem,
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                },
                iconStyleData: const IconStyleData(
                  icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (selectedItem == null) {
                      FlashHelper.errorMessage(context,
                          message: 'Please select a location');
                      return;
                    }
                    widget.user.setUserLocation(selectedItem!);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    );
                  },
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Confirm',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: 0.8),
                  ),
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
              ),
            ]
          ],
        ),
      ),
    );
  }
}
