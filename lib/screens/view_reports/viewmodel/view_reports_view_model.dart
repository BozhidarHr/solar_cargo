import 'package:flutter/material.dart';
import 'package:solar_cargo/models/paging_response.dart';
import 'package:solar_cargo/screens/view_reports/model/delivery_report.dart';

import '../../../../services/services.dart';
import '../../common/logger.dart';

class ViewReportsViewModel with ChangeNotifier {
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
}
