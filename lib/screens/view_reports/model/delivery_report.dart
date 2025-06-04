class DeliveryReport {
  final int? id;
  final String? location;
  final String? checkingCompany;
  final String? supplier;
  final String? deliverySlipNumber;
  final String? logisticCompany;
  final String? containerNumber;
  final String? licencePlateTruck;
  final String? licencePlateTrailer;
  final String? weatherConditions;
  final String? comments;
  final String? createdAt;
  final String? updatedAt;
  final int? user;

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
    this.comments,
    this.createdAt,
    this.updatedAt,
    this.user,
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
      comments: json['comments'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'location': location,
      'checking_company': checkingCompany,
      'supplier': supplier,
      'delivery_slip_number': deliverySlipNumber,
      'logistic_company': logisticCompany,
      'container_number': containerNumber,
      'licence_plate_truck': licencePlateTruck,
      'licence_plate_trailer': licencePlateTrailer,
      'weather_conditions': weatherConditions,
      'comments': comments,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user': user,
    };
  }
}
