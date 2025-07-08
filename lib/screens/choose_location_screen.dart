import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'common/flash_helper.dart';
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
  String? selectedItem;

  @override
  Widget build(BuildContext context) {
    final List<String> locations = widget.user.locations;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            DropdownButton2<String>(
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
              items: locations.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
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
          ],
        ),
      ),
    );
  }
}
