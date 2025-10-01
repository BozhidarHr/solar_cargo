import 'dart:io';

import 'package:solar_cargo/screens/common/string_extension.dart';

import '../../common/user_location.dart';
import '../../create_report/models/checkbox_comment.dart';
import '../../create_report/models/delivery_item.dart';

class DeliveryReport {
  int? id;
  UserLocation? pvProject;
  String? subcontractor;
  String? supplier;
  String? deliverySlipNumber;
  String? logisticCompany;
  String? containerNumber;
  String? licencePlateTruck;
  String? licencePlateTrailer;
  bool? includesDamages;
  String? damagesDescription;
  List<DeliveryItem> deliveryItems;
  String? comments;
  List<CheckBoxItem> checkboxItems;
  String? weatherConditions;
  int? userId;

  // File? or String?
  dynamic truckLicencePlateImage;
  dynamic trailerLicencePlateImage;
  dynamic proofOfDelivery;
  dynamic cmrImage;
  dynamic deliverySlipImages;
  dynamic additionalImages;
  dynamic damagesImages;

  DeliveryReport({
    this.id,
    this.pvProject,
    this.supplier,
    this.deliverySlipNumber,
    this.logisticCompany,
    this.containerNumber,
    this.licencePlateTruck,
    this.licencePlateTrailer,
    this.weatherConditions,
    this.includesDamages,
    this.damagesDescription,
    List<DeliveryItem>? deliveryItems,
    this.comments,
    List<CheckBoxItem>? checkboxItems,
    this.userId,
    this.truckLicencePlateImage,
    this.trailerLicencePlateImage,
    this.proofOfDelivery,
    this.cmrImage,
    this.deliverySlipImages,
    this.additionalImages,
    this.damagesImages,
  })  : subcontractor = 'S&G Solar',
        deliveryItems = deliveryItems ?? [DeliveryItem.empty()],
        checkboxItems = checkboxItems ?? CheckBoxItem.defaultStep3Items();

  factory DeliveryReport.fromJson(Map<String, dynamic> json) {
    return DeliveryReport(
      id: json['id'],
      pvProject: UserLocation.fromJsonPVLocation(json),
      supplier: json['supplier_name'],
      deliverySlipNumber: json['delivery_slip_number'],
      logisticCompany: json['logistic_company'],
      containerNumber: json['container_number'],
      licencePlateTruck: json['licence_plate_truck'],
      licencePlateTrailer: json['licence_plate_trailer'],
      damagesDescription: json['damage_description'],
      weatherConditions: json['weather_conditions'],
      deliveryItems: (json['items'] != null)
          ? (json['items'] as List)
          .map((e) => DeliveryItem.fromJson(Map<String, dynamic>.from(e)))
          .toList()
          : [],
      comments: json['comments'],
      checkboxItems: CheckBoxItem.listFromFlatJson(json),
      userId: json['user'],
    );
  }

  factory DeliveryReport.fromLocalJson(Map<String, dynamic> json) {
    return DeliveryReport(
      id: json['id'],
      pvProject: UserLocation.fromJson(json['pvProject'] ?? {}),
      supplier: json['supplier_name'],
      deliverySlipNumber: json['delivery_slip_number'],
      logisticCompany: json['logistic_company'],
      containerNumber: json['container_number'],
      truckLicencePlateImage: _fileFromPath(json['truckLicencePlateImage']),
      trailerLicencePlateImage: _fileFromPath(json['trailerLicencePlateImage']),
      licencePlateTruck: json['licence_plate_truck'],
      licencePlateTrailer: json['licence_plate_trailer'],
      damagesDescription: json['damage_description'],
      weatherConditions: json['weather_conditions'],
      deliveryItems: (json['items'] != null)
          ? (json['items'] as List)
          .map((e) =>
          DeliveryItem.fromLocalJson(Map<String, dynamic>.from(e)))
          .toList()
          : [],
      comments: json['comments'],
      proofOfDelivery: _fileFromPath(json['proofOfDelivery']),
      cmrImage: _fileFromPath(json['cmrImage']),
      deliverySlipImages: _fileListFromPaths(json['deliverySlipImages']),
      additionalImages: _fileListFromPaths(json['additionalImages']),
      damagesImages: _fileListFromPaths(json['damagesImages']),
      checkboxItems: CheckBoxItem.listFromFlatJson(json),
      includesDamages: json['includesDamages'] ?? false,
      userId: json['user'],
    );
  }

  String get buildHeaderText {
    final List<String> headerText = [];

    if (logisticCompany.isNotNullAndNotEmpty) {
      headerText.add(logisticCompany!);
    }

    if (supplier.isNotNullAndNotEmpty) {
      headerText.add(supplier!);
    }

    return headerText.join(' | ');
  }

  /// Converts the DeliveryReport object to a JSON-serializable map
  Map<String, dynamic> toLocalJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'pvProject': pvProject?.toJson(),
      'subcontractor': subcontractor,
      'supplier_name': supplier,
      'delivery_slip_number': deliverySlipNumber,
      'logistic_company': logisticCompany,
      'container_number': containerNumber,
      'licence_plate_truck': licencePlateTruck,
      'licence_plate_trailer': licencePlateTrailer,
      'includesDamages': includesDamages,
      'damage_description': damagesDescription,
      'weather_conditions': weatherConditions,
      'items': deliveryItems.map((e) => e.toJson()).toList(),
      'comments': comments,
      'user': userId,
      'truckLicencePlateImage': _getFilePath(truckLicencePlateImage),
      'trailerLicencePlateImage': _getFilePath(trailerLicencePlateImage),
      'proofOfDelivery': _getFilePath(proofOfDelivery),
      'cmrImage': _getFilePath(cmrImage),
      'deliverySlipImages': _getFileListPaths(deliverySlipImages),
      'additionalImages': _getFileListPaths(additionalImages),
      'damagesImages': _getFileListPaths(damagesImages),
    };

    // Merge flat checkbox fields into root
    json.addAll(CheckBoxItem.listToFlatJson(checkboxItems));

    return json;
  }

  // ---------- Helpers ----------

  static String? _getFilePath(dynamic fileOrPath) {
    if (fileOrPath == null) return null;
    if (fileOrPath is File) return fileOrPath.path;
    if (fileOrPath is String) return fileOrPath;
    return null;
  }

  static List<String>? _getFileListPaths(dynamic files) {
    if (files == null) return null;
    if (files is List) {
      return files
          .map((e) => _getFilePath(e) ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    }
    return null;
  }

  static File? _fileFromPath(dynamic fileOrPath) {
    if (fileOrPath == null) return null;
    if (fileOrPath is String && fileOrPath.isNotEmpty) return File(fileOrPath);
    if (fileOrPath is File) return fileOrPath;
    return null;
  }

  static List<File>? _fileListFromPaths(dynamic paths) {
    if (paths == null) return null;
    if (paths is List) {
      return paths
          .map((e) => _fileFromPath(e))
          .where((f) => f != null && (f as File).existsSync())
          .cast<File>()
          .toList();
    }
    return null;
  }
}
