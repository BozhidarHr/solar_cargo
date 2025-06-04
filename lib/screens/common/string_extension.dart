import '../../routes/routes.dart';

extension StringExtensions on String {
  bool get hasOnlyWhitespaces => trim().isEmpty && isNotEmpty;

  bool get isListView => this != 'horizontal';

  String toSpaceSeparated() {
    final value =
    replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ');
    return value;
  }

  String formatCopy() {
    return replaceAll('},', '\n},\n')
        .replaceAll('[{', '[\n{\n')
        .replaceAll(',"', ',\n"')
        .replaceAll('{"', '{\n"')
        .replaceAll('}]', '\n}\n]');
  }

  bool get isNoInternetError => contains('SocketException: Failed host lookup');

  bool get isURLImage => isNotEmpty && (contains('http') || contains('https'));

  Uri? toUri() => Uri.tryParse(this);

  String capitalize() {
    if (length <= 1) {
      return toUpperCase();
    }

    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String upperCaseFirstChar() {
    if (length <= 1) {
      return toUpperCase();
    }

    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String toTitleCase() =>
      split(' ').map((str) => str.upperCaseFirstChar()).join(' ');

  RoutingData get getRoutingData {
    final uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }


  String removeLeadingZeros() {
    for (var i = 0; i < length; i++) {
      if (this[i] != '0') {
        return substring(i);
      }
    }
    return '0';
  }

  String clearExceptionKey() {
    return replaceAll('Exception: ', '');
  }
}
