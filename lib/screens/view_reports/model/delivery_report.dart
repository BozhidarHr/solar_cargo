
import 'package:intl/intl.dart';

import '../../create_report/models/checkbox_comment.dart';
import '../../create_report/models/delivery_item.dart';

class DeliveryReport {
  int? id;
  String? location;
  String? checkingCompany;
  String? supplier;
  String? deliverySlipNumber;
  String? logisticCompany;
  String? containerNumber;
  String? licencePlateTruck;
  String? licencePlateTrailer;
  List<DeliveryItem>? deliveryItems = [];
  String? weatherConditions;
  String? comments;
  String? createdAt;
  String? updatedAt;
  int? user;

  // File? or String?
  dynamic truckLicencePlateImage;
  dynamic trailerLicencePlateImage;
  dynamic proofOfDelivery;
  List<CheckBoxItem> checkboxItems = [];
  dynamic cmrImage;
  dynamic deliverySlipImage;
  List<dynamic>? additionalImages;

  DeliveryReport({
    this.id,
    this.location,
    this.checkingCompany,
    this.supplier,
    this.deliverySlipNumber,
    this.logisticCompany,
    this.containerNumber,
    this.licencePlateTruck,
    this.licencePlateTrailer,
    this.weatherConditions,
    this.deliveryItems,
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.truckLicencePlateImage,
    this.trailerLicencePlateImage,
    this.proofOfDelivery,
  });

  factory DeliveryReport.fromJson(Map<String, dynamic> json) {
    return DeliveryReport(
      id: json['id'],
      location: json['location'],
      checkingCompany: json['checking_company'],
      supplier: json['supplier'],
      deliverySlipNumber: json['delivery_slip_number'],
      logisticCompany: json['logistic_company'],
      containerNumber: json['container_number'],
      licencePlateTruck: json['licence_plate_truck'],
      licencePlateTrailer: json['licence_plate_trailer'],
      weatherConditions: json['weather_conditions'],
      truckLicencePlateImage: json['truck_license_plate_image'],
      trailerLicencePlateImage: json['trailer_license_plate_image'],
      comments: json['comments'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'],
    );
  }

  // Map<String, dynamic> toJson() {
  //   final checkboxItemsJson = CheckBoxItem.listToFlatJson(checkboxItems);
  //   return {
  //     'items_input': deliveryItems?.map((e) => e.toJson).toList() ?? [],
  //     'location': location,
  //     'checking_company': checkingCompany,
  //     'supplier': supplier,
  //     'delivery_slip_number': deliverySlipNumber,
  //     'logistic_company': logisticCompany,
  //     'container_number': containerNumber,
  //     // Hardcoded for now
  //     'licence_plate_truck': 'РР 1234 ВК',
  //     'licence_plate_trailer': 'РР 5678 ВК',
  //     'truck_license_plate_image':  truckLicencePlateImage ,
  //     'trailer_license_plate_image': trailerLicencePlateImage ,
  //     'weather_conditions': weatherConditions,
  //     // not needed field
  //     'comments': null,
  //     // all checkbox items
  //     ...checkboxItemsJson,
  //     'user': 1,
  //   };
  // }

  String? get createdAtDate {
    if (createdAt == null) return null;
    try {
      return DateFormat('yy/MM/dd').format(DateTime.parse(createdAt!));
    } catch (_) {
      return null;
    }
  }

  String? get updatedAtDate {
    if (updatedAt == null) return null;
    try {
      return DateFormat('yy/MM/dd').format(DateTime.parse(updatedAt!));
    } catch (_) {
      return null;
    }
  }
}
