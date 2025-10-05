import 'delivery_report.dart';

class DeliveryReportImage {
  String? fileName;
  String? content;

  DeliveryReportImage({
    this.fileName,
    this.content,
  });

  factory DeliveryReportImage.fromJson(Map json) {
    return DeliveryReportImage(
      fileName: json['filename'],
      content: json['content'],
    );
  }
}

extension DeliveryReportImages on DeliveryReport {
  /// Parses image fields from request data into DeliveryReportImage objects.
  void updateImagesFromRequest(Map json) {
    final licensePlates = (json['license_plates'] as List?) ?? [];
    if (licensePlates.isNotEmpty) {
      truckLicencePlateImage = DeliveryReportImage.fromJson(licensePlates[0]);
      if (licensePlates.length > 1) {
        trailerLicencePlateImage = DeliveryReportImage.fromJson(licensePlates[1]);
      }
    }

    cmrImage = _parseSingleImage(json, 'cmr');

    goodsContainerSeal = _parseImageList(json, 'gsc_proof');
    deliverySlipImages = _parseImageList(json, 'delivery_slips');
    damagesImages = _parseImageList(json, 'damage_images');
    additionalImages = _parseImageList(json, 'additional');
  }

  /// Parses a single image (expects a list with one element)
  DeliveryReportImage? _parseSingleImage(Map json, String key) {
    final list = json[key] as List?;
    final first = (list != null && list.isNotEmpty) ? list.first : null;
    return first != null ? DeliveryReportImage.fromJson(first) : null;
  }

  /// Parses a list of images
  List<DeliveryReportImage> _parseImageList(Map json, String key) {
    final list = json[key] as List?;
    return (list ?? []).map((e) => DeliveryReportImage.fromJson(e)).toList();
  }}
