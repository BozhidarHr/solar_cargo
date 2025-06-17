import 'package:solar_cargo/services/solar_services.dart';

import '../env.dart';

class Services {
  static final Services _instance = Services._internal();

  factory Services() => _instance;

  Services._internal();

  late final SolarServices api = SolarServices(
    domain: Env.apiUrl,
  );

}
