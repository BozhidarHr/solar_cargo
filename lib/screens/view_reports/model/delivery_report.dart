import 'package:solar_cargo/screens/common/string_extension.dart';

import '../../create_report/models/checkbox_comment.dart';
import '../../create_report/models/delivery_item.dart';

class DeliveryReport {
  int? id;
  String? pvProject;
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
  String? weatherComment;
  int? user;

  // File? or String?
  dynamic truckLicencePlateImage;
  dynamic trailerLicencePlateImage;
  dynamic proofOfDelivery;
  dynamic cmrImage;
  dynamic deliverySlipImage;
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
    this.weatherComment,
    this.includesDamages,
    this.damagesDescription,
    List<DeliveryItem>? deliveryItems,
    this.comments,
    List<CheckBoxItem>? checkboxItems,
    this.user,
    this.truckLicencePlateImage,
    this.trailerLicencePlateImage,
    this.proofOfDelivery,
    this.cmrImage,
    this.deliverySlipImage,
    this.additionalImages,
    this.damagesImages,
  })  : subcontractor = 'S&G Solar',
        deliveryItems = deliveryItems ?? [DeliveryItem.empty()],
        checkboxItems = checkboxItems ?? CheckBoxItem.defaultStep3Items();

  factory DeliveryReport.fromJson(Map<String, dynamic> json) {
    return DeliveryReport(
      id: json['id'],
      pvProject: json['pv_project'],
      supplier: json['supplier'],
      deliverySlipNumber: json['delivery_slip_number'],
      logisticCompany: json['logistic_company'],
      containerNumber: json['container_number'],
      licencePlateTruck: json['licence_plate_truck'],
      licencePlateTrailer: json['licence_plate_trailer'],
      truckLicencePlateImage: json['truck_license_plate_image'],
      trailerLicencePlateImage: json['trailer_license_plate_image'],
      damagesDescription: json['damages_description'],
      weatherConditions: json['weather_conditions'],
      weatherComment: json['weather_comments'],
      proofOfDelivery: json['proof_of_delivery_image'],
      deliveryItems: (json['items'] != null)
          ? (json['items'] as List)
              .map((e) => DeliveryItem.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : [],
      comments: json['comments'],
      checkboxItems: CheckBoxItem.listFromFlatJson(json),
      cmrImage: json['cmr_image'],
      deliverySlipImage: json['delivery_slip_image'],
      additionalImages:
          (json['additional_images_urls'])?.map((e) => e['image']).toList() ??
              [],
      damagesImages:
      (json['damages_images_urls'])?.map((e) => e['image']).toList() ??
          [],
      user: json['user'],
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
