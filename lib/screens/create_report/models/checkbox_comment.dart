enum ReportOption { ok, notOk, na }

class CheckBoxItem {
  String name; // Not nullable since it's the key
  String? label;
  ReportOption? selectedOption;
  String? comment;

  CheckBoxItem({
    required this.name,
    this.label,
    this.selectedOption,
    this.comment,
  });

  /// Converts list to flat map JSON format: {name_status: bool?, name_comment: String?}
  static Map<String, dynamic> listToFlatJson(List<CheckBoxItem> items) {
    final Map<String, dynamic> result = {};
    for (var item in items) {
      result['${item.name}_status'] = _reportOptionToBool(item.selectedOption);
      result['${item.name}_comment'] = item.comment;
    }
    return result;
  }

  /// Reconstructs a list of CheckBoxItem from flat JSON map
  static List<CheckBoxItem> listFromFlatJson(Map<String, dynamic> flatJson) {
    final Set<String> itemNames = flatJson.keys
        .where((key) => key.endsWith('_status'))
        .map((key) => key.replaceFirst('_status', ''))
        .toSet();

    return itemNames.map((name) {
      final dynamic statusValue = flatJson['${name}_status'];
      final String? commentValue = flatJson['${name}_comment']?.toString();

      ReportOption? option;
      if (statusValue == true) {
        option = ReportOption.ok;
      } else if (statusValue == false) {
        option = ReportOption.notOk;
      } else {
        option = ReportOption.na;
      }

      return CheckBoxItem(
        name: name,
        label: getDescriptionForName(name),
        selectedOption: option,
        comment: commentValue,
      );
    }).toList();
  }

  /// Converts ReportOption to boolean (ok = true, notOk = false, na/null = null)
  static bool? _reportOptionToBool(ReportOption? option) {
    switch (option) {
      case ReportOption.ok:
        return true;
      case ReportOption.notOk:
        return false;
      case ReportOption.na:
      case null:
        return null;
    }
  }

  /// Maps short key name to descriptive label
  static String getDescriptionForName(String name) {
    switch (name) {
      case 'load_secured':
        return 'Load properly secured';
      case 'goods_according':
        return 'Goods according to delivery and PO, amount and identity';
      case 'packaging':
        return 'Packaging sufficient and stable enough';
      case 'delivery_without_damages':
        return 'Delivery without damages';
      case 'suitable_machines':
        return 'Suitable machines for unloading/handling present';
      case 'delivery_slip':
        return 'Delivery slip scanned, uploaded and filed';
      case 'inspection_report':
        return 'Inspection Report scanned, uploaded and filed';
      default:
        return name; // fallback
    }
  }

  /// Returns default check items as list
  static List<CheckBoxItem> defaultStep3Items() {
    final names = [
      'load_secured',
      'goods_according',
      'packaging',
      'delivery_without_damages',
      'suitable_machines',
      'delivery_slip',
      'inspection_report',
    ];

    return [
      for (var name in names)
        CheckBoxItem(
          name: name,
          label: getDescriptionForName(name),
        ),
    ];
  }}
