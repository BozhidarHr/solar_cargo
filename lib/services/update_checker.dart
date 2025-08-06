import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:solar_cargo/screens/common/constants.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../screens/common/logger.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAppVersionAndClearStorageIfNeeded();
      checkForUpdate(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Compare stored version with current version, clear secure storage if changed
Future<void> _checkAppVersionAndClearStorageIfNeeded() async {
  const secureStorage = FlutterSecureStorage();
  final packageInfo = await PackageInfo.fromPlatform();
  final currentVersion = packageInfo.version;

  final savedVersion = await secureStorage.read(key: 'app_version');

  if (savedVersion == null || savedVersion != currentVersion) {
    printLog('App updated: $savedVersion → $currentVersion. Clearing secure storage...');

    // Clear all stored tokens & secure data
    await secureStorage.deleteAll();

    // Save new version
    await secureStorage.write(key: 'app_version', value: currentVersion);
  }
}

Future<void> checkForUpdate(BuildContext context) async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    final response = await http.get(Uri.parse(versionUrl));
    if (response.statusCode != 200) return;

    final data = jsonDecode(response.body);
    final latestVersion = data['latest_version'];
    final apkUrl = data['apk_url'];
    final changelog = data['changelog'] ?? '';
    if (_isNewerVersion(latestVersion, currentVersion)) {
      _showUpdateDialog(context, apkUrl, changelog);
    }
  } catch (e) {
    debugPrint('Update check failed: $e');
  }
}

bool _isNewerVersion(String latest, String current) {
  // Split version and build number (e.g. "1.0.4+5")
  List<String> splitVersion(String version) {
    final parts = version.split('+');
    return parts.length == 2 ? parts : [version, '0'];
  }

  final latestParts = splitVersion(latest);
  final currentParts = splitVersion(current);

  // Parse main version numbers into int list
  List<int> parseVersionNumbers(String version) =>
      version.split('.').map(int.parse).toList();

  final latestNums = parseVersionNumbers(latestParts[0]);
  final currentNums = parseVersionNumbers(currentParts[0]);

  final maxLength = latestNums.length > currentNums.length ? latestNums.length : currentNums.length;

  // Compare main version parts
  for (int i = 0; i < maxLength; i++) {
    final latestNum = i < latestNums.length ? latestNums[i] : 0;
    final currentNum = i < currentNums.length ? currentNums[i] : 0;

    if (latestNum > currentNum) return true;
    if (latestNum < currentNum) return false;
  }

  // If main versions equal, compare build number (after '+')
  final latestBuild = int.tryParse(latestParts[1]) ?? 0;
  final currentBuild = int.tryParse(currentParts[1]) ?? 0;

  return latestBuild > currentBuild;
}


void _showUpdateDialog(BuildContext context, apkUrl, String changelog) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: kFormFieldBackgroundColor,
      title: const Text('Update Available'),
      content: Text('A new version is available.\n\n$changelog'),
      actions: [
        Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 45,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor, // Green button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.pop(dialogContext);
                try {
                  await launchUrlString(apkUrl,
                      mode: LaunchMode.externalApplication);
                } catch (e) {
                  printLog('Failed to launch URL: $e');
                }
              },
              child: Text(
                'Update',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
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
