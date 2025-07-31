import 'package:flutter/material.dart';
import 'package:solar_cargo/models/paging_response.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report_image.dart';

import '../../../../services/services.dart';
import '../../../services/api_response.dart';
import '../../common/logger.dart';

class ViewReportsViewModel with ChangeNotifier {
  // Download report
  ApiResponse _downloadReportResponse = ApiResponse.initial('Empty data');

  ApiResponse get downloadResponse => _downloadReportResponse;

  // Fetching delivery report images

   ApiResponse _fetchImagesResponse =
      ApiResponse.initial('Empty data');

  ApiResponse get fetchImagesResponse => _fetchImagesResponse;

  final Services _service = Services();

  final _allReports = <DeliveryReport>[];

  List<DeliveryReport> get allReports => _allReports;

  int _currentPage = 1;
  String? _nextPageUrl;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool get hasMorePages => _nextPageUrl != null && !_isLoadingMore;

  void resetDownloadResponse() {
    _downloadReportResponse = ApiResponse.initial('Empty data');
  }

  Future<void> fetchAndAssignImages({required DeliveryReport report}) async{
    _fetchImagesResponse =
          ApiResponse.loading('fetchAndAssignImages delivery report ...');
      notifyListeners();
      try {
        if (report.id == null) {
          throw Exception('Cannot fetch report images: reportId == null');
        }
        final imagesJson = await _service.api
            .fetchReportImages(reportId: report.id!);

        report.updateImagesFromRequest(imagesJson);
        _fetchImagesResponse = ApiResponse.completed(imagesJson);
      } catch (e) {
        _fetchImagesResponse = ApiResponse.error(e.toString());
        logger.w('fetchAndAssignImages(catch): ${e.toString()}');
      }

      notifyListeners();

  }

  Future<void> fetchDeliveryReports({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _nextPageUrl = null;
      _allReports.clear();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final PagingResponse<DeliveryReport> deliveryReports =
          await _service.api.fetchDeliveryReports(page: _currentPage);

      _allReports.addAll(deliveryReports.results);
      _nextPageUrl = deliveryReports.next;
      _currentPage++;
    } catch (e) {
      _errorMessage = e.toString();
      logger.w('fetchDeliveryReports(catch): $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDeliveryReportsByLocation(
      {required int? locationId, bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _currentPage = 1;
      _nextPageUrl = null;
      _allReports.clear();
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (locationId == null) {
        throw Exception('Cannot fetch reports: locationId == null');
      }
      final PagingResponse<DeliveryReport> deliveryReports = await _service.api
          .fetchDeliveryReportsByLocation(
              locationId: locationId, page: _currentPage);

      _allReports.addAll(deliveryReports.results);
      if (allReports.isEmpty) {
        _errorMessage = 'No delivery reports found for this location.';
      }
      _nextPageUrl = deliveryReports.next;
      _currentPage++;
    } catch (e) {
      _errorMessage = e.toString();
      logger.w('fetchDeliveryReportsByLocation(catch): $_errorMessage');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNextPage() async {
    if (!hasMorePages || _isLoadingMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final PagingResponse<DeliveryReport> deliveryReports =
          await _service.api.fetchDeliveryReports(page: _currentPage);

      _allReports.addAll(deliveryReports.results);
      _nextPageUrl = deliveryReports.next;
      _currentPage++;
    } catch (e) {
      logger.w('fetchNextPage(catch): ${e.toString()}');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> downloadReport({
    required bool isPdf,
    required int? reportId,
  }) async {
    _downloadReportResponse =
        ApiResponse.loading('Downloading delivery report ...');
    notifyListeners();
    try {
      if (reportId == null) {
        throw Exception('Cannot download report: reportId == null');
      }
      final file = await _service.api
          .downloadReport(isPdf: isPdf, reportId: reportId.toString());

      _downloadReportResponse = ApiResponse.completed(file?.path);
    } catch (e) {
      _downloadReportResponse = ApiResponse.error(e.toString());
      logger.w('downloadReport(catch): ${e.toString()}');
    }

    notifyListeners();
  }
}
