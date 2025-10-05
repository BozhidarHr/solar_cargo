import 'dart:convert' as convert;
import 'dart:io';

import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:solar_cargo/screens/common/string_extension.dart';
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
    await tokenStorage.write(StorageItem.bearerToken, token);
    _customerToken = token;
  }

  setRefreshToken(String token) async {
    await tokenStorage.write(StorageItem.refreshToken, token);
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
      _refreshToken = await tokenStorage.read(StorageItem.refreshToken);
      if (_refreshToken == null || _refreshToken!.isEmpty) {
        throw Exception(
            'No refresh token available. Please logout and login again.');
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

  Future<PagingResponse<DeliveryReport>> fetchDeliveryReportsByLocation(
      {required int locationId, int page = 1}) async {
    try {
      const apiPageSize = 10;
      // Build URL with page param
      var url = SolarHelper.buildUrl(domain,
          'reports-by-location/$locationId/?page=$page&page_size=$apiPageSize',
          includeApiPath: false);
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

  Future<Map> fetchReportImages({
    required int reportId,
  }) async {
    try {
      // Build URL with page param
      var url = SolarHelper.buildUrl(
          domain, 'delivery-reports/$reportId/download-media/',
          includeApiPath: false);
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
      return responseBody['media_data'];
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

  Future<void> changeProfilePicture({
    required File profilePicture,
  }) async {
    final url = SolarHelper.buildUrl(domain, '/profile/update-picture/');

    try {
      final response = await sendWithAuth((token) async {
        final request = http.MultipartRequest('PATCH', url!);
        request.headers[HttpHeaders.authorizationHeader] =
            'Bearer $_customerToken';

        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          profilePicture.path,
        ));

        final streamedResponse = await request.send();
        return await http.Response.fromStream(streamedResponse);
      });

      final responseBody = convert.jsonDecode(response.body);

      if (response.statusCode != 200) {
        final error = responseBody is Map && responseBody['message'] != null
            ? SolarHelper.getErrorMessage(responseBody)
            : 'Plate recognition failed with status code ${response.statusCode}';
        throw Exception(error);
      }
    } catch (e) {
      printLog('Error changing profile picture: $e');
    }
  }

  Future<void> createDeliveryReport(DeliveryReport newReport) async {
    try {
      final url = SolarHelper.buildUrl(domain, '/delivery-reports/');

      final response = await sendWithAuth((token) async {
        final request = http.MultipartRequest('POST', url!);
        request.headers[HttpHeaders.authorizationHeader] = 'Bearer $token';

        // Fields
        request.fields['location'] = newReport.pvProject?.id.toString() ?? '6';
        request.fields['checking_company'] = newReport.subcontractor ?? '';
        request.fields['supplier_input'] = newReport.supplier ?? '';
        request.fields['delivery_slip_number'] =
            newReport.deliverySlipNumber ?? '';
        request.fields['logistic_company'] = newReport.logisticCompany ?? '';
        request.fields['container_number'] = newReport.containerNumber ?? '';
        request.fields['licence_plate_truck'] =
            newReport.licencePlateTruck ?? '';
        request.fields['licence_plate_trailer'] =
            newReport.licencePlateTrailer ?? '';
        request.fields['comments'] = newReport.comments ?? '';
        request.fields['weather_conditions'] =
            newReport.weatherConditions ?? '';
        request.fields['user'] = newReport.userId.toString();
        request.fields['damage_description'] =
            newReport.damagesDescription ?? '';
        // Delivery items
        final itemsJson =
            newReport.deliveryItems.map((e) => e.toJson()).toList();
        request.fields['items_input'] = convert.jsonEncode(itemsJson);

        // Checkbox fields
        final checkboxFields =
            CheckBoxItem.listToFlatJson(newReport.checkboxItems.toList());
        checkboxFields.forEach((key, value) {
          request.fields[key] = value?.toString() ?? '';
        });

        // Add images if they exist
        final imageFields = {
          'truck_license_plate_image': newReport.truckLicencePlateImage,
          'trailer_license_plate_image': newReport.trailerLicencePlateImage,
          'cmr_image': newReport.cmrImage,
        };

        imageFields.forEach((field, file) async {
          if (file is File) {
            request.files
                .add(await http.MultipartFile.fromPath(field, file.path));
          }
        });

        final listImageFields = {
          'goods_seal_container_proof': newReport.goodsContainerSeal,
          'delivery_slip_images_input': newReport.deliverySlipImages,
          'damage_images_input': newReport.damagesImages,
          'additional_images_input': newReport.additionalImages,
        };

        listImageFields.forEach((field, files) async {
          if (files != null) {
            for (final file in files) {
              request.files
                  .add(await http.MultipartFile.fromPath(field, file.path));
            }
          }
        });

        // Build cURL for debugging
        String curl = 'curl -X POST \'${url.toString()}\' \\\n';
        request.headers.forEach((key, value) {
          curl += '-H \'$key: $value\' \\\n';
        });
        request.fields.forEach((key, value) {
          final escapedValue = value.replaceAll('\'', '\\\'');
          curl += '-F \'$key=$escapedValue\' \\\n';
        });
        for (var file in request.files) {
          curl += '-F \'${file.field}=@${file.filename}\' \\\n';
        }
        printLog('cURL command:\n$curl');

        // Send request
        final streamedResponse = await request.send();
        return await http.Response.fromStream(streamedResponse);
      });

      final responseBody = convert.jsonDecode(response.body);
      if (response.statusCode != 200 && response.statusCode != 201) {
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }

      // Clear saved draft
      final box = await Hive.openBox('delivery_reports');
      await box.delete('current_report');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> plateRecognition({
    required File truckImage,
    required File trailerImage,
  }) async {
    final url = SolarHelper.buildUrl(domain, '/recognize-plates/');

    try {
      final response = await sendWithAuth((token) async {
        final request = http.MultipartRequest('POST', url!);
        request.headers[HttpHeaders.authorizationHeader] =
            'Bearer $_customerToken';

        // Attach truck license plate image
        request.files.add(await http.MultipartFile.fromPath(
          'truck_plate_image',
          truckImage.path,
        ));

        // Attach trailer license plate image
        request.files.add(await http.MultipartFile.fromPath(
          'trailer_plate_image',
          trailerImage.path,
        ));

        final streamedResponse = await request.send();
        return await http.Response.fromStream(streamedResponse);
      });

      final responseBody = convert.jsonDecode(response.body);

      if (response.statusCode != 200) {
        final error = responseBody is Map && responseBody['message'] != null
            ? SolarHelper.getErrorMessage(responseBody)
            : 'Plate recognition failed with status code ${response.statusCode}';
        throw Exception(error);
      }

      return {
        'truckPlateText': responseBody['truck_plate'] ?? '',
        'trailerPlateText': responseBody['trailer_plate'] ?? '',
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>?> searchSuppliers(int location, String query) async {
    try {
      // Build URL with page param
      var url = SolarHelper.buildUrl(
          domain, 'locations/$location/suppliers?q=$query',
          includeApiPath: false);
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

  Future<List<String>?> searchItemsByLocation(
      int location, String query) async {
    try {
      // Build URL with page param
      var url = SolarHelper.buildUrl(
        domain,
        '/items/autocomplete?q=$query&location=$location',
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

  Future<File?> downloadReport({
    required bool isPdf,
    required String reportId,
  }) async {
    try {
      // Build URL
      final url =
          '$domain/download-report/$reportId/${isPdf ? 'pdf' : 'excel'}/'
              .toUri();

      final response = await sendWithAuth((token) {
        return http.get(
          url!,
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer $_customerToken',
          },
        );
      });

      if (response.statusCode != 200) {
        final responseBody = convert.jsonDecode(response.body);
        if (responseBody is Map && responseBody['message'] != null) {
          throw Exception(SolarHelper.getErrorMessage(responseBody));
        }
        throw Exception(
            'Unknown error occurred with status code ${response.statusCode}');
      }

      final ext = isPdf ? 'pdf' : 'xlsx';
      final fileName = 'report_$reportId.$ext';

      Directory dir;

      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = (await getExternalStorageDirectory())!;
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }

      final filePath = '${dir.path}/$fileName';
      final file = File(filePath);

      try {
        await file.writeAsBytes(response.bodyBytes);
        printLog('File saved at ${file.path}');
      } catch (e) {
        printLog('Error saving file: $e');
      }

      return file;
    } catch (e) {
      rethrow;
    }
  }
}
