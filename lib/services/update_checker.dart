import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:solar_cargo/screens/common/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;


class UpdateChecker extends StatefulWidget {
  final Widget child;
  const UpdateChecker({required this.child, super.key});

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


Future<void> checkForUpdate(BuildContext context) async {
  try {
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  final response = await http.get(Uri.parse(versionUrl));
  if (response.statusCode != 200) return;

  final data = jsonDecode(response.body);
  final latestVersion = data['latest_version'];
  final apkUrl = data['apk_url'];
  final changelog = data['changelog'] ?? '';
  if (_isNewerVersion(latestVersion, currentVersion)) {
  _showUpdateDialog(context ,apkUrl, changelog);
  }
  }
  catch (e) {
    debugPrint('Update check failed: $e');
  }
}

bool _isNewerVersion(String latest, String current) {
  final latestParts = latest.split('.').map(int.parse).toList();
  final currentParts = current.split('.').map(int.parse).toList();

  for (int i = 0; i < latestParts.length; i++) {
    if (i >= currentParts.length || latestParts[i] > currentParts[i]) return true;
    if (latestParts[i] < currentParts[i]) return false;
  }
  return false;
}

void _showUpdateDialog(BuildContext context, apkUrl, String changelog) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: kFormFieldBackgroundColor,
      title: const Text('Update Available'),
      content:  Text('A new version is available.\n$changelog'),
      actions: [

        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                Theme.of(context).primaryColor, // Green button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                final uri = Uri.parse(apkUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: Text(
                'Update',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(
                  fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}