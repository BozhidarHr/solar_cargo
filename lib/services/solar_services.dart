import 'dart:convert' as convert;
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:solar_cargo/services/solar_helper.dart';

import '../models/jwt_keys.dart';
import '../models/paging_response.dart';
import '../models/token_storage.dart';
import '../screens/common/logger.dart';
import '../screens/create_report/models/checkbox_comment.dart';
import '../screens/view_reports/model/delivery_report.dart';
import 'http_client.dart';

class SolarServices {
  final String domain;

  SolarServices({
    required this.domain,
  });

  String? _customerToken;
  String? _refreshToken;

  final TokenStorage tokenStorage = TokenStorage();

  String? get customerToken => _customerToken;

  setCustomerToken(String token) async {
    await tokenStorage.write(TokenType.bearer, token);
    _customerToken = token;
  }

  setRefreshToken(String token) async {
    await tokenStorage.write(TokenType.refresh, token);
    _refreshToken = token;
  }

  Future<JwtKeys> login(String username, String password) async {
    try {
      var url = SolarHelper.buildUrl(
        domain,
        '/auth/login',
      );
      var body = {
        'username': username,
        'password': password,
      };
      var response = await httpPost(
        url!,
        body: convert.jsonEncode(body),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }
      var responseBody = convert.jsonDecode(response.body);

      if (response.statusCode != 200) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }

      final refreshToken = responseBody?['refresh'];
      final bearerToken = responseBody?['access'];

      if (bearerToken == null || bearerToken.isEmpty) {
        throw Exception('Bearer token not found in response');
      }

      await setCustomerToken(bearerToken);
      await setRefreshToken(refreshToken);
      return JwtKeys(
        bearerToken: bearerToken,
        refreshToken: refreshToken,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> updateToken() async {
    try {
      _refreshToken = await tokenStorage.read(TokenType.refresh);
      if (_refreshToken == null || _refreshToken!.isEmpty) {
        throw Exception('No refresh token available');
      }
      var url = SolarHelper.buildUrl(
        domain,
        '/auth/refresh',
      );
      var body = {"refresh": _refreshToken};
      var response = await httpPost(
        url!,
        body: convert.jsonEncode(body),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }
      var responseBody = convert.jsonDecode(response.body);

      if (response.statusCode != 200) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }

      final bearerToken = responseBody?['access'];
      await setCustomerToken(bearerToken);
      return bearerToken;
    } catch (e) {
      rethrow;
    }
  }

  Future<PagingResponse<DeliveryReport>> fetchDeliveryReports(
      {int page = 1}) async {
    try {
      const apiPageSize = 10;
      // Build URL with page param
      var url = SolarHelper.buildUrl(
        domain,
        '/delivery-reports?page=$page&page_size=$apiPageSize',
      );
      // Make GET request
      var response = await sendWithAuth((token) {
        return http.get(
          url!,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $_customerToken',
          },
        );
      });

      // Decode response
      var responseBody = convert.jsonDecode(response.body);

      // Error handling
      if (response.statusCode != 200) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }

      // Parse and return paging response
      return PagingResponse<DeliveryReport>.fromJson(
        responseBody,
        (item) => DeliveryReport.fromJson(item),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createDeliveryReport(DeliveryReport newReport) async {
    try {
      var url = SolarHelper.buildUrl(domain, '/delivery-reports/');

      final response = await sendWithAuth((token) async {
        var request = http.MultipartRequest('POST', url!);
        request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

        // Fields
        request.fields['location'] = newReport.location ?? '';
        request.fields['checking_company'] = newReport.checkingCompany ?? '';
        request.fields['supplier'] = newReport.supplier ?? '';
        request.fields['delivery_slip_number'] =
            newReport.deliverySlipNumber ?? '';
        request.fields['logistic_company'] = newReport.logisticCompany ?? '';
        request.fields['container_number'] = newReport.containerNumber ?? '';
        request.fields['licence_plate_truck'] = newReport.licencePlateTruck ?? '';
        request.fields['licence_plate_trailer'] = newReport.licencePlateTrailer ?? '';

        // Truck licence plate image
        if (newReport.truckLicencePlateImage is File) {
          request.files.add(await http.MultipartFile.fromPath(
            'truck_license_plate_image',
            (newReport.truckLicencePlateImage as File).path,
          ));
        }

        // Trailer licence plate image
        if (newReport.trailerLicencePlateImage is File) {
          request.files.add(await http.MultipartFile.fromPath(
            'trailer_license_plate_image',
            (newReport.trailerLicencePlateImage as File).path,
          ));
        }

        request.fields['weather_conditions'] =
            newReport.weatherConditions ?? '';

        // Delivery items
        final itemsJson =
        newReport.deliveryItems.map((e) => e.toJson()).toList();
        request.fields['items_input'] = convert.jsonEncode(itemsJson);

        // Proof of delivery image
        if (newReport.proofOfDelivery is File) {
          request.files.add(await http.MultipartFile.fromPath(
            'proof_of_delivery_image',
            (newReport.proofOfDelivery as File).path,
          ));
        }

        // Checkbox fields
        final checkboxFields =
        CheckBoxItem.listToFlatJson(newReport.checkboxItems.toList());
        checkboxFields.forEach((key, value) {
          request.fields[key] = value?.toString() ?? '';
        });

        // CMR image
        if (newReport.cmrImage is File) {
          request.files.add(await http.MultipartFile.fromPath(
            'cmr_image',
            (newReport.cmrImage as File).path,
          ));
        }

        // Delivery slip image
        if (newReport.deliverySlipImage is File) {
          request.files.add(await http.MultipartFile.fromPath(
            'delivery_slip_image',
            (newReport.deliverySlipImage as File).path,
          ));
        }

        // Additional images
        if (newReport.additionalImages is List<File>) {
          final images = newReport.additionalImages as List<File>;
          for (final file in images) {
            request.files.add(await http.MultipartFile.fromPath(
              'additional_images_input',
              file.path,
            ));
          }
        }

        request.fields['user'] = '${newReport.user ?? 1}';

        // Send request and get response
        var streamedResponse = await request.send();
        return await http.Response.fromStream(streamedResponse);
      });

      var responseBody = convert.jsonDecode(response.body);

      if (response.statusCode != 200 && response.statusCode != 201) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>?> searchItems(String query) async {
    try {
      // Build URL with page param
      var url = SolarHelper.buildUrl(
        domain,
        '/items/autocomplete?q=$query',
      );
      // Make GET request
      var response = await sendWithAuth((token) {
        return httpGet(
          url!,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $_customerToken',
          },
        );
      });

      // Decode response
      var responseBody = convert.jsonDecode(response.body);

      // Error handling
      if (response.statusCode != 200) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }

      // Parse and return paging response
      return responseBody
          .map<String>((item) => item['name'].toString())
          .toList();
    } catch (e) {
      printLog('Search error: $e');
      return [];
    }
  }
}
