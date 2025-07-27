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
      truckLicencePlateImage: json['truck_license_plate_image'],
      trailerLicencePlateImage: json['trailer_license_plate_image'],
      damagesDescription: json['damage_description'],
      weatherConditions: json['weather_conditions'],
      proofOfDelivery: json['proof_of_delivery_image'],
      deliveryItems: (json['items'] != null)
          ? (json['items'] as List)
              .map((e) => DeliveryItem.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
      comments: json['comments'],
      checkboxItems: CheckBoxItem.listFromFlatJson(json),
      cmrImage: json['cmr_image'],
      deliverySlipImages: (json['delivery_slip_images_urls'])?.map((e) => e['image']).toList() ??
          [],
      additionalImages:
          (json['additional_images_urls'])?.map((e) => e['image']).toList() ??
              [],
      damagesImages:
      (json['damage_images_urls'])?.map((e) => e['image']).toList() ??
          [],
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

    return headerText.join(
      ' | ',
    );
  }

// String? get createdAtDate {
//   if (createdAt == null) return null;
//   try {
//     return DateFormat('yy/MM/dd').format(DateTime.parse(createdAt!));
//   } catch (_) {
//     return null;
//   }
// }
//
// String? get updatedAtDate {
//   if (updatedAt == null) return null;
//   try {
//     return DateFormat('yy/MM/dd').format(DateTime.parse(updatedAt!));
//   } catch (_) {
//     return null;
//   }
// }
}
