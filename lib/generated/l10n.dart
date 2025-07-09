// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name =
        (locale.countryCode?.isEmpty ?? false)
            ? locale.languageCode
            : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Solar-cargo`
  String get appTitle {
    return Intl.message('Solar-cargo', name: 'appTitle', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Email address`
  String get email {
    return Intl.message('Email address', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `An error occurred, please try again.`
  String get errorTryAgain {
    return Intl.message(
      'An error occurred, please try again.',
      name: 'errorTryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Please fill in all fields.`
  String get fillFieldsError {
    return Intl.message(
      'Please fill in all fields.',
      name: 'fillFieldsError',
      desc: '',
      args: [],
    );
  }

  /// `User with matching login credentials not found.`
  String get userNotFound {
    return Intl.message(
      'User with matching login credentials not found.',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Supplier`
  String get supplier {
    return Intl.message('Supplier', name: 'supplier', desc: '', args: []);
  }

  /// `Truck`
  String get truck {
    return Intl.message('Truck', name: 'truck', desc: '', args: []);
  }

  /// `Create new report`
  String get createNewReport {
    return Intl.message(
      'Create new report',
      name: 'createNewReport',
      desc: '',
      args: [],
    );
  }

  /// `Step 1: Delivery Information`
  String get step1Title {
    return Intl.message(
      'Step 1: Delivery Information',
      name: 'step1Title',
      desc: '',
      args: [],
    );
  }

  /// `Truck License Plate`
  String get truckLicensePlate {
    return Intl.message(
      'Truck License Plate',
      name: 'truckLicensePlate',
      desc: '',
      args: [],
    );
  }

  /// `Trailer License Plate`
  String get trailerLicensePlate {
    return Intl.message(
      'Trailer License Plate',
      name: 'trailerLicensePlate',
      desc: '',
      args: [],
    );
  }

  /// `PV Project`
  String get pvProject {
    return Intl.message('PV Project', name: 'pvProject', desc: '', args: []);
  }

  /// `Subcontractor`
  String get subcontractor {
    return Intl.message(
      'Subcontractor',
      name: 'subcontractor',
      desc: '',
      args: [],
    );
  }

  /// `Delivery slip No`
  String get deliverySlipNumber {
    return Intl.message(
      'Delivery slip No',
      name: 'deliverySlipNumber',
      desc: '',
      args: [],
    );
  }

  /// `Logistics company`
  String get logisticsCompany {
    return Intl.message(
      'Logistics company',
      name: 'logisticsCompany',
      desc: '',
      args: [],
    );
  }

  /// `Container No`
  String get containerNumber {
    return Intl.message(
      'Container No',
      name: 'containerNumber',
      desc: '',
      args: [],
    );
  }

  /// `Weather conditions`
  String get weatherConditions {
    return Intl.message(
      'Weather conditions',
      name: 'weatherConditions',
      desc: '',
      args: [],
    );
  }

  /// `Browse`
  String get browse {
    return Intl.message('Browse', name: 'browse', desc: '', args: []);
  }

  /// `Take Photo`
  String get takePhoto {
    return Intl.message('Take Photo', name: 'takePhoto', desc: '', args: []);
  }

  /// `Choose from Gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from Gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `No image selected`
  String get noImageSelected {
    return Intl.message(
      'No image selected',
      name: 'noImageSelected',
      desc: '',
      args: [],
    );
  }

  /// `Proof of delivery`
  String get proofOfDelivery {
    return Intl.message(
      'Proof of delivery',
      name: 'proofOfDelivery',
      desc: '',
      args: [],
    );
  }

  /// `CMR image`
  String get cmrImage {
    return Intl.message('CMR image', name: 'cmrImage', desc: '', args: []);
  }

  /// `Delivery slip image`
  String get deliverySlipImage {
    return Intl.message(
      'Delivery slip image',
      name: 'deliverySlipImage',
      desc: '',
      args: [],
    );
  }

  /// `Additional images`
  String get additionalImages {
    return Intl.message(
      'Additional images',
      name: 'additionalImages',
      desc: '',
      args: [],
    );
  }

  /// `Comments`
  String get comments {
    return Intl.message('Comments', name: 'comments', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'bg'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
